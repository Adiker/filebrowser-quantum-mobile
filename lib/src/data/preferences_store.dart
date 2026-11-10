import 'package:shared_preferences/shared_preferences.dart';

import '../api/models.dart';

enum BrowserViewMode { grid, list }

enum AppearanceMode { system, light, dark }

enum AppearanceColor { system, indigo, blue, teal, green, orange, pink }

/// SharedPreferences-backed store for lightweight, non-secret UI preferences.
///
/// Secrets (credentials, JWT) live in `SecureStore`; this holds only durable
/// view state. Kept intentionally small — later milestones extend it with
/// view-mode, last-path, etc. by adding a key + typed getter/setter pair.
class PreferencesStore {
  PreferencesStore(this._prefs);

  /// Convenience async constructor that resolves the shared instance.
  static Future<PreferencesStore> create() async =>
      PreferencesStore(await SharedPreferences.getInstance());

  final SharedPreferences _prefs;

  static const _kSortKey = 'pref_sort_key';
  static const _kSortAsc = 'pref_sort_asc';
  static const _kDownloadDir = 'pref_download_dir';
  static const _kSourceName = 'pref_source_name';
  static const _kViewMode = 'pref_view_mode';
  static const _kGridSize = 'pref_grid_size';
  static const _kListSize = 'pref_list_size';

  bool get autoUpdateChecks => _prefs.getBool('auto_update_checks') ?? true;

  Future<void> setAutoUpdateChecks(bool enabled) async =>
      _prefs.setBool('auto_update_checks', enabled);

  String? get downloadedUpdateVersion =>
      _prefs.getString('downloaded_update_version');

  Future<void> setDownloadedUpdateVersion(String? version) async {
    if (version == null) {
      await _prefs.remove('downloaded_update_version');
    } else {
      await _prefs.setString('downloaded_update_version', version);
    }
  }

  String? get downloadedUpdateRecord =>
      _prefs.getString('downloaded_update_record');

  Future<void> setDownloadedUpdateRecord(String? record) async {
    final ok = record == null
        ? await _prefs.remove('downloaded_update_record')
        : await _prefs.setString('downloaded_update_record', record);
    if (!ok) throw StateError('Could not persist update metadata');
  }

  DateTime? get lastUpdateCheck {
    final timestamp = _prefs.getInt('last_update_check');
    return timestamp == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  Future<void> setLastUpdateCheck(DateTime time) async =>
      _prefs.setInt('last_update_check', time.millisecondsSinceEpoch);

  BrowserViewMode get viewMode => BrowserViewMode.values.firstWhere(
        (mode) => mode.name == _prefs.get(_kViewMode),
        orElse: () => BrowserViewMode.grid,
      );

  Future<void> setViewMode(BrowserViewMode mode) async =>
      _prefs.setString(_kViewMode, mode.name);

  // Sizes are normalized to the slider range and validated on read.
  double viewSize(BrowserViewMode mode) {
    final value =
        _prefs.get(mode == BrowserViewMode.grid ? _kGridSize : _kListSize);
    return value is double && value.isFinite && value >= 0 && value <= 1
        ? value
        : 0.5;
  }

  Future<void> setViewSize(BrowserViewMode mode, double value) async {
    final safe = value.isFinite ? value.clamp(0.0, 1.0) : 0.5;
    await _prefs.setDouble(
        mode == BrowserViewMode.grid ? _kGridSize : _kListSize, safe);
  }

  AppearanceMode get appearanceMode => AppearanceMode.values.firstWhere(
        (value) => value.name == _prefs.get('pref_appearance_mode'),
        orElse: () => AppearanceMode.system,
      );

  Future<void> setAppearanceMode(AppearanceMode value) async =>
      _prefs.setString('pref_appearance_mode', value.name);

  AppearanceColor get appearanceColor => AppearanceColor.values.firstWhere(
        (value) => value.name == _prefs.get('pref_appearance_color'),
        orElse: () => AppearanceColor.system,
      );

  Future<void> setAppearanceColor(AppearanceColor value) async =>
      _prefs.setString('pref_appearance_color', value.name);

  bool get amoled => _prefs.get('pref_amoled') == true;

  Future<void> setAmoled(bool value) async =>
      _prefs.setBool('pref_amoled', value);

  /// Persisted sort column (defaults to [SortKey.name]).
  SortKey get sortKey {
    final raw = _prefs.getString(_kSortKey);
    return SortKey.values.firstWhere(
      (k) => k.name == raw,
      orElse: () => SortKey.name,
    );
  }

  /// Persisted sort direction (defaults to ascending).
  bool get sortAscending => _prefs.getBool(_kSortAsc) ?? true;

  /// Both sort dimensions as a record, with the defaults applied.
  ({SortKey key, bool ascending}) get sort =>
      (key: sortKey, ascending: sortAscending);

  /// Persists the sort preference. Returns once both writes complete.
  Future<void> setSort(SortKey key, bool ascending) async {
    await _prefs.setString(_kSortKey, key.name);
    await _prefs.setBool(_kSortAsc, ascending);
  }

  /// The last download save-location the user picked (an absolute device path
  /// from the SAF directory picker), or null when none has been chosen — in
  /// which case downloads land in the app's private storage. Empty strings are
  /// normalised to null so a cleared value behaves like "never set".
  String? get downloadDir {
    final v = _prefs.getString(_kDownloadDir);
    return (v == null || v.isEmpty) ? null : v;
  }

  /// Persists (or, with a null/empty [dir], clears) the default download
  /// save-location offered for subsequent downloads.
  Future<void> setDownloadDir(String? dir) async {
    if (dir == null || dir.isEmpty) {
      await _prefs.remove(_kDownloadDir);
    } else {
      await _prefs.setString(_kDownloadDir, dir);
    }
  }

  /// The browsing source the user last selected, or null when none has been
  /// chosen yet. Restored on launch/relogin and injected into the client before
  /// any browsing. Empty strings normalise to null.
  String? get sourceName {
    final v = _prefs.getString(_kSourceName);
    return (v == null || v.isEmpty) ? null : v;
  }

  /// Persists (or, with a null/empty [name], clears) the selected source.
  Future<void> setSourceName(String? name) async {
    if (name == null || name.isEmpty) {
      await _prefs.remove(_kSourceName);
    } else {
      await _prefs.setString(_kSourceName, name);
    }
  }
}
