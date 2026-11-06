import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

import '../api/filebrowser_client.dart';
import '../api/models.dart';
import '../data/preferences_store.dart';
import 'secure_store.dart';

enum AuthStage {
  /// No stored credentials — show the setup form (server URL + credentials).
  needsSetup,

  /// Credentials exist; waiting for biometric unlock.
  locked,

  /// Logged in, but the server exposes several sources and none is remembered —
  /// the user must pick one before browsing.
  needsSource,

  /// A valid JWT is held and a source is selected; the file browser is usable.
  authenticated,

  /// A biometric/network step is in flight.
  busy,
}

/// Orchestrates: stored credentials -> biometric gate -> direct login -> source
/// selection -> authenticated session.
///
/// Login is a direct `POST /api/auth/login`, so a fresh token can always be
/// minted from the credentials in secure storage. The JWT is cached and kept
/// alive via renew; on an unrecoverable session we simply log in again.
class AuthController extends ChangeNotifier {
  AuthController({
    required PreferencesStore prefs,
    SecureStore? store,
    LocalAuthentication? localAuth,
    Future<void> Function()? onForget,
  })  : _prefs = prefs,
        _store = store ?? SecureStore(),
        _localAuth = localAuth ?? LocalAuthentication(),
        _onForget = onForget;

  final PreferencesStore _prefs;
  final SecureStore _store;
  final LocalAuthentication _localAuth;

  /// Invoked on "sign out & forget" so dependent services (e.g. the transfer
  /// service's persisted task database, which caches auth headers) can wipe
  /// any session state they hold outside secure storage.
  final Future<void> Function()? _onForget;

  AuthStage _stage = AuthStage.busy;
  AuthStage get stage => _stage;

  String? _error;
  String? get error => _error;

  FileBrowserClient? _client;
  FileBrowserClient? get client => _client;

  FbUser? _user;
  FbUser? get user => _user;

  List<String> _availableSources = const [];

  /// Source names offered on the [AuthStage.needsSource] selector.
  List<String> get availableSources => _availableSources;

  Future<void> bootstrap() async {
    _setStage(AuthStage.busy);
    _stage =
        (await _store.hasCredentials) ? AuthStage.locked : AuthStage.needsSetup;
    notifyListeners();
  }

  Future<bool> hasHttpConsent(String baseUrl) async {
    final normalized = FileBrowserClient(baseUrl: baseUrl).baseUrl;
    return _store.hasHttpConsent(normalized);
  }

  /// First-run: persist the server URL + credentials, then log in directly.
  Future<void> beginSetup({
    required String baseUrl,
    required String username,
    required String password,
    bool confirmHttp = false,
  }) async {
    _setStage(AuthStage.busy);
    final String normalized;
    try {
      normalized = FileBrowserClient(baseUrl: baseUrl).baseUrl;
    } catch (e) {
      _fail('Invalid server URL: ${_friendly(e)}', AuthStage.needsSetup);
      return;
    }
    if (Uri.parse(normalized).scheme == 'http' &&
        !confirmHttp &&
        !await _store.hasHttpConsent(normalized)) {
      _fail('Confirm the unencrypted connection before signing in.',
          AuthStage.needsSetup);
      return;
    }
    await _store.setHttpConsent(
        Uri.parse(normalized).scheme == 'http' ? normalized : null);
    await _store.save(
        baseUrl: normalized, username: username, password: password);
    await _store.clearJwt();
    await _loginAndSelectSource(normalized, username, password,
        onFailure: AuthStage.needsSetup);
  }

  /// Biometric unlock -> reuse a still-valid cached JWT, else log in directly.
  Future<bool> unlockWithBiometrics() async {
    _setStage(AuthStage.busy);
    try {
      final supported = await _localAuth.isDeviceSupported();
      if (supported) {
        final ok = await _localAuth.authenticate(
          localizedReason: 'Unlock File Browser',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: false, // allow device PIN/pattern fallback
          ),
        );
        if (!ok) {
          _fail('Biometric authentication was cancelled.', AuthStage.locked);
          return false;
        }
      }
      final creds = await _store.read();
      if (creds == null) {
        _stage = AuthStage.needsSetup;
        notifyListeners();
        return false;
      }

      if (Uri.parse(creds.baseUrl).scheme == 'http' &&
          !await _store.hasHttpConsent(creds.baseUrl)) {
        _fail(
            'HTTP connection requires confirmation. Use a different server to set it up again.',
            AuthStage.locked);
        return false;
      }

      // Reuse a cached token while it is still valid; otherwise log in again.
      final cached = await _store.readJwt();
      if (cached != null && FileBrowserClient.isTokenValid(cached)) {
        _adoptClient(creds.baseUrl, cached, username: creds.username);
        await _resolveSource(_client!);
        return true;
      }

      await _loginAndSelectSource(creds.baseUrl, creds.username, creds.password,
          onFailure: AuthStage.locked);
      return true;
    } catch (e) {
      _fail('Unlock failed: ${_friendly(e)}', AuthStage.locked);
      return false;
    }
  }

  /// Confirms the source the user picked on the [AuthStage.needsSource] selector.
  Future<void> selectSource(String name) async {
    _client?.setSource(name);
    await _prefs.setSourceName(name);
    _availableSources = const [];
    _setStage(AuthStage.authenticated);
  }

  /// Changes the browsing source without replacing the authenticated session.
  Future<void> switchSource(String name) async {
    final activeClient = client;
    if (activeClient == null || activeClient.source == name) return;
    await _prefs.setSourceName(name);
    if (identical(client, activeClient)) {
      activeClient.setSource(name);
      notifyListeners();
    }
  }

  Future<void> signOut({bool forget = false}) async {
    if (forget) {
      await _store.clear();
      await _prefs.setSourceName(null);
      await _onForget?.call();
    } else {
      await _store.clearJwt();
    }
    _client = null;
    _user = null;
    _availableSources = const [];
    _stage = forget ? AuthStage.needsSetup : AuthStage.locked;
    notifyListeners();
  }

  /// On-demand session freshness check: renews the cached JWT if the server
  /// asked us to or it is nearing expiry. Call on screen resume and when a
  /// transfer is enqueued. A hard failure re-runs the direct login via
  /// [onSessionExpired] (no relock, no loop).
  Future<void> ensureFreshSession() async {
    final client = _client;
    if (client == null) return;
    try {
      await client.ensureFreshSession();
    } on SessionExpiredException {
      // onSessionExpired already re-ran the direct login.
    } catch (_) {
      // Transient network errors keep the current session; the 401 path will
      // handle a genuinely dead token on the next authenticated request.
    }
  }

  /// Logs in directly with [username]/[password] against [baseUrl], caches the
  /// JWT, and resolves the browsing source. Failures land on [onFailure] with a
  /// human-readable error.
  Future<void> _loginAndSelectSource(
    String baseUrl,
    String username,
    String password, {
    required AuthStage onFailure,
  }) async {
    try {
      final client = FileBrowserClient(baseUrl: baseUrl);
      final user = await client.login(username, password);
      _wireClient(client);
      _user = user;
      await _store.saveJwt(client.token!);
      await _resolveSource(client);
    } catch (e) {
      _fail('Sign in failed: ${_friendly(e)}', onFailure);
    }
  }

  /// Picks the source [client] will browse: restore a remembered choice, else
  /// auto-select when there is exactly one, else route to the selector.
  Future<void> _resolveSource(FileBrowserClient client) async {
    final saved = _prefs.sourceName;
    Map<String, FbSource> sources;
    try {
      sources = await client.listSources();
    } catch (_) {
      // Can't enumerate sources (e.g. permissions): fall back to a remembered
      // choice if any, then browse — a missing source just yields empty calls.
      if (saved != null) client.setSource(saved);
      _setStage(AuthStage.authenticated);
      return;
    }
    if (saved != null && sources.containsKey(saved)) {
      client.setSource(saved);
      _setStage(AuthStage.authenticated);
      return;
    }
    if (sources.length == 1) {
      final name = sources.keys.first;
      client.setSource(name);
      await _prefs.setSourceName(name);
      _setStage(AuthStage.authenticated);
      return;
    }
    if (sources.isEmpty) {
      _setStage(AuthStage.authenticated);
      return;
    }
    _availableSources = sources.keys.toList();
    _setStage(AuthStage.needsSource);
  }

  void _adoptClient(String baseUrl, String jwt, {String username = ''}) {
    final client = FileBrowserClient(baseUrl: baseUrl);
    client.adoptToken(jwt);
    _wireClient(client);
    final decoded = FileBrowserClient.userFromToken(jwt);
    _user = FbUser(
      username: username,
      canCreate: decoded.canCreate,
      canModify: decoded.canModify,
    );
  }

  void _wireClient(FileBrowserClient client) {
    // Persist renewed tokens so the cached JWT stays fresh between launches.
    client.onTokenChanged = (t) => _store.saveJwt(t);
    // A dead session (401 + failed renew) re-runs the direct login.
    client.onSessionExpired = _handleSessionExpired;
    _client = client;
  }

  /// Re-runs the direct login from stored credentials when the session expires
  /// irrecoverably. We never relock behind biometrics here.
  Future<void> _handleSessionExpired() async {
    await _store.clearJwt();
    final creds = await _store.read();
    if (creds == null) {
      _stage = AuthStage.needsSetup;
      notifyListeners();
      return;
    }
    if (Uri.parse(creds.baseUrl).scheme == 'http' &&
        !await _store.hasHttpConsent(creds.baseUrl)) {
      _fail('HTTP connection requires confirmation.', AuthStage.locked);
      return;
    }
    await _loginAndSelectSource(creds.baseUrl, creds.username, creds.password,
        onFailure: AuthStage.locked);
  }

  void _setStage(AuthStage s) {
    _stage = s;
    _error = null;
    notifyListeners();
  }

  void _fail(String message, AuthStage fallback) {
    _error = message;
    _stage = _client != null ? AuthStage.authenticated : fallback;
    notifyListeners();
  }

  String _friendly(Object e) {
    final s = e.toString();
    return s.length > 160 ? '${s.substring(0, 160)}…' : s;
  }
}
