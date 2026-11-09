import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../update/update_controller.dart';

final updateNavigatorKey = GlobalKey<NavigatorState>();

class UpdateBanner extends StatelessWidget {
  const UpdateBanner({super.key});
  @override
  Widget build(BuildContext context) {
    final update = context.watch<UpdateController>();
    if (update.release == null || update.dismissed) {
      return const SizedBox.shrink();
    }
    final loc = AppLocalizations.of(context);
    return Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: SafeArea(
            child: Material(
          elevation: 4,
          color: Theme.of(context).colorScheme.primaryContainer,
          child: ListTile(
            leading: const Icon(Icons.system_update),
            title: Text('${loc.updateAvailable}: ${update.release!.version}'),
            onTap: () {
              update.dismiss();
              updateNavigatorKey.currentState?.push(
                  MaterialPageRoute(builder: (_) => const UpdateScreen()));
            },
            trailing: IconButton(
                icon: const Icon(Icons.close), onPressed: update.dismiss),
          ),
        )));
  }
}

class UpdateScreen extends StatelessWidget {
  const UpdateScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final update = context.watch<UpdateController>();
    final loc = AppLocalizations.of(context);
    final release = update.release;
    return Scaffold(
      appBar: AppBar(title: Text(loc.updateTitle)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        SwitchListTile(
          value: update.prefs.autoUpdateChecks,
          onChanged: update.setAutomatic,
          title: Text(loc.updateAutomatic),
          subtitle: Text(loc.updateAutomaticHint),
        ),
        if (update.currentVersion.isNotEmpty)
          ListTile(
              title: Text(loc.updateCurrent),
              subtitle: Text(update.currentVersion)),
        OutlinedButton.icon(
          onPressed: update.checking || update.downloading
              ? null
              : () => update.check(),
          icon: const Icon(Icons.refresh),
          label: Text(update.checking ? loc.updateChecking : loc.updateCheck),
        ),
        if (update.checking) const LinearProgressIndicator(),
        if (update.checked &&
            release == null &&
            update.error == null &&
            !update.checking)
          Padding(
              padding: const EdgeInsets.all(16), child: Text(loc.updateLatest)),
        if (release != null) ...[
          const SizedBox(height: 20),
          Text('${loc.updateAvailable}: ${release.version}',
              style: Theme.of(context).textTheme.titleLarge),
          Text(
              '${loc.updateSize}: ${(release.size / (1024 * 1024)).toStringAsFixed(1)} MiB'),
          if (release.notes.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(loc.updateNotes,
                style: Theme.of(context).textTheme.titleMedium),
            SelectableText(release.notes),
          ],
          const SizedBox(height: 16),
          if (update.downloading) ...[
            Text(loc.updateProgress),
            LinearProgressIndicator(value: update.progress),
            Text('${(update.progress * 100).toStringAsFixed(0)}%'),
            TextButton(
                onPressed: update.cancelDownload,
                child: Text(loc.updateCancel)),
          ] else if (update.apk == null)
            FilledButton.icon(
                onPressed: update.checking ? null : update.download,
                icon: const Icon(Icons.download),
                label: Text(update.error == null
                    ? loc.updateDownload
                    : loc.updateTryAgain))
          else
            FilledButton.icon(
                onPressed: update.checking ? null : update.install,
                icon: const Icon(Icons.install_mobile),
                label: Text(loc.updateInstall)),
          if (update.permissionRequired)
            Padding(
                padding: const EdgeInsets.all(8),
                child: Text(loc.updatePermission)),
          TextButton(
              onPressed: () {
                update.dismiss();
                Navigator.of(context).maybePop();
              },
              child: Text(loc.updateLater)),
        ],
        if (update.error != null)
          Padding(
              padding: const EdgeInsets.all(8),
              child: Text('${loc.updateError}: ${update.error}',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.error))),
      ]),
    );
  }
}
