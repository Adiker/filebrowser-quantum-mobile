import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../api/filebrowser_client.dart';
import '../api/models.dart';
import '../auth/auth_controller.dart';
import 'error_display.dart';
import 'shares_screen.dart';
import 'update_screen.dart';

/// Whether disk-usage figures are meaningful. A source that is unindexed (or
/// reports no capacity) yields `total=0`, so a zero total means "unavailable"
/// rather than a full/empty disk. PURE — see `status_screen_test.dart`.
bool diskUsageAvailable(FbUsage usage) => usage.total > 0;

/// Loads server settings, degrading to `null` instead of throwing.
///
/// `GET /api/settings` is admin-only and returns 403 for normal users;
/// any failure (403, network, parse) collapses to `null` so the Status screen
/// can simply omit the server-info section. PURE-ish (no UI) — see
/// `status_screen_test.dart`.
Future<FbServerCaps?> tryLoadSettings(FileBrowserClient client) async {
  try {
    return await client.getSettings();
  } catch (_) {
    return null;
  }
}

/// Status / Settings page: disk usage, the signed-in user, and (when the user
/// is an admin) server info — plus Lock and Sign-out actions.
///
/// Disk usage is intentionally surfaced here and NOT on the main grid.
class StatusScreen extends StatefulWidget {
  const StatusScreen({
    super.key,
    required this.client,
    required this.user,
  });

  final FileBrowserClient client;
  final FbUser? user;

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  late Future<FbUsage?> _usage;
  late Future<FbServerCaps?> _settings;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _usage = widget.client.diskUsage();
    _settings = tryLoadSettings(widget.client);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(loc.statusTitle)),
      body: RefreshIndicator(
        onRefresh: () async => setState(_load),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _section(loc.statusSectionStorage),
            _usageCard(),
            const SizedBox(height: 24),
            _section(loc.statusSectionAccount),
            _userCard(),
            const SizedBox(height: 24),
            _section(loc.statusSectionServer),
            _serverCard(),
            const SizedBox(height: 24),
            Card(
                child: ListTile(
              leading: const Icon(Icons.system_update),
              title: Text(loc.updateTitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const UpdateScreen(),
              )),
            )),
            _actions(context),
          ],
        ),
      ),
    );
  }

  Widget _section(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(title,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: Theme.of(context).colorScheme.primary)),
      );

  Widget _usageCard() {
    return FutureBuilder<FbUsage?>(
      future: _usage,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        if (snap.hasError) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: CopyableErrorView(
                message: snap.error.toString(),
                onRetry: () => setState(_load),
              ),
            ),
          );
        }
        final loc = AppLocalizations.of(context);
        final usage = snap.data;
        if (usage == null || !diskUsageAvailable(usage)) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.help_outline),
              title: Text(loc.statusDiskUsageUnavailable),
              subtitle: Text(loc.statusDiskUsageUnavailableHint),
            ),
          );
        }
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: usage.usedFraction,
                    minHeight: 10,
                  ),
                ),
                const SizedBox(height: 12),
                Text(loc.statusUsedOfTotal(usage.usedHuman, usage.totalHuman,
                    (usage.usedFraction * 100).toStringAsFixed(1))),
                const SizedBox(height: 4),
                Text(loc.statusFree(usage.freeHuman),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _userCard() {
    final loc = AppLocalizations.of(context);
    final user = widget.user;
    final perms = <String>[
      if (user?.canCreate ?? false) loc.statusPermCreate,
      if (user?.canModify ?? false) loc.statusPermModify,
    ];
    return Card(
      child: ListTile(
        leading: const Icon(Icons.person_outline),
        title: Text(user?.username.isNotEmpty == true
            ? user!.username
            : loc.statusUnknownUser),
        subtitle: Text(perms.isEmpty
            ? loc.statusReadOnly
            : loc.statusPermissions(perms.join(', '))),
      ),
    );
  }

  Widget _serverCard() {
    return FutureBuilder<FbServerCaps?>(
      future: _settings,
      builder: (context, snap) {
        final loc = AppLocalizations.of(context);
        if (snap.connectionState == ConnectionState.waiting) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.dns_outlined),
              title: Text(loc.statusLoadingServerInfo),
            ),
          );
        }
        final caps = snap.data;
        if (caps == null) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.dns_outlined),
              title: Text(loc.statusServerInfoUnavailable),
              subtitle: Text(loc.statusRequiresAdmin),
            ),
          );
        }
        return Card(
          child: ListTile(
            leading: const Icon(Icons.dns_outlined),
            title: Text(caps.name.isEmpty ? loc.appTitle : caps.name),
            subtitle: Text(caps.signup
                ? loc.statusSignupEnabled
                : loc.statusSignupDisabled),
          ),
        );
      },
    );
  }

  Widget _actions(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final auth = context.read<AuthController>();
    return Column(
      children: [
        OutlinedButton.icon(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => SharesScreen(client: widget.client),
          )),
          icon: const Icon(Icons.link),
          label: Text(loc.statusManageSharedLinks),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => auth.signOut(),
          icon: const Icon(Icons.lock_outline),
          label: Text(widget.user != null
              ? loc.lockWithUser(widget.user!.username)
              : loc.actionLock),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error),
          onPressed: () => auth.signOut(forget: true),
          icon: const Icon(Icons.logout),
          label: Text(loc.actionSignOutForget),
        ),
      ],
    );
  }
}
