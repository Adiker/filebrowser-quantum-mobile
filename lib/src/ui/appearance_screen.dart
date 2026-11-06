import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../appearance.dart';
import '../data/preferences_store.dart';

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
          DropdownButtonFormField<AppearanceMode>(
            initialValue: appearance.mode,
            decoration: InputDecoration(labelText: loc.appearanceMode),
            items: [
              for (final entry in modeNames.entries)
                DropdownMenuItem(value: entry.key, child: Text(entry.value))
            ],
            onChanged: (value) {
              if (value != null) appearance.setMode(value);
            },
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
          DropdownButtonFormField<AppearanceColor>(
            initialValue: appearance.color,
            decoration: InputDecoration(labelText: loc.appearanceColor),
            isExpanded: true,
            items: [
              for (final entry in colorNames.entries)
                DropdownMenuItem(
                    value: entry.key,
                    child: Row(children: [
                      if (entry.key == AppearanceColor.system)
                        const Icon(Icons.palette_outlined)
                      else
                        Icon(Icons.circle,
                            color: AppearanceController.seedFor(entry.key)),
                      const SizedBox(width: 12),
                      Flexible(
                          child: Text(entry.value,
                              overflow: TextOverflow.ellipsis)),
                    ]))
            ],
            onChanged: (value) {
              if (value != null) appearance.setColor(value);
            },
          ),
          const SizedBox(height: 8),
          Text(loc.appearanceDynamicHint,
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
