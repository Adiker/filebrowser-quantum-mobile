import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../appearance.dart';
import '../data/preferences_store.dart';
import 'anchored_choice.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final appearance = context.watch<AppearanceController>();
    final modeNames = {
      AppearanceMode.system: loc.appearanceSystem,
      AppearanceMode.light: loc.appearanceLight,
      AppearanceMode.dark: loc.appearanceDark,
    };
    final colorNames = {
      AppearanceColor.system: loc.appearanceDynamic,
      AppearanceColor.indigo: loc.appearanceIndigo,
      AppearanceColor.blue: loc.appearanceBlue,
      AppearanceColor.teal: loc.appearanceTeal,
      AppearanceColor.green: loc.appearanceGreen,
      AppearanceColor.orange: loc.appearanceOrange,
      AppearanceColor.pink: loc.appearancePink,
    };
    return Scaffold(
      appBar: AppBar(title: Text(loc.appearanceTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AnchoredChoice<AppearanceMode>(
            label: loc.appearanceMode,
            value: appearance.mode,
            choices: {
              for (final entry in modeNames.entries)
                entry.key: Text(entry.value),
            },
            onChanged: appearance.setMode,
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(loc.appearanceAmoled),
            subtitle: Text(loc.appearanceAmoledHint),
            value: appearance.amoled,
            onChanged: appearance.setAmoled,
          ),
          const SizedBox(height: 16),
          AnchoredChoice<AppearanceColor>(
            label: loc.appearanceColor,
            value: appearance.color,
            choices: {
              for (final entry in colorNames.entries)
                entry.key: Row(
                  children: [
                    if (entry.key == AppearanceColor.system)
                      const Icon(Icons.palette_outlined)
                    else
                      Icon(
                        Icons.circle,
                        color: AppearanceController.seedFor(entry.key),
                      ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(entry.value, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
            },
            onChanged: appearance.setColor,
          ),
          const SizedBox(height: 8),
          Text(
            loc.appearanceDynamicHint,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
