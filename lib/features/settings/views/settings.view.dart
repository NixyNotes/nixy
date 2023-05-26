import 'package:auto_route/auto_route.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';
import 'package:nextcloudnotes/core/shared/components/scaffold.component.dart';
import 'package:nextcloudnotes/features/settings/controllers/settings_view.controller.dart';
import 'package:settings_ui/settings_ui.dart';

@RoutePage()
class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final controller = getIt<SettingsViewController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    getIt.resetLazySingleton<SettingsViewController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      innerPadding: false,
      body: SettingsList(
        sections: [
          SettingsSection(
              title: const Text("Current Nextcloud Instance"),
              tiles: [
                SettingsTile(
                    title: Observer(builder: (_) {
                      return Text(controller.currentAccount?.server ?? "");
                    }),
                    leading: const Icon(
                      EvaIcons.activity,
                    )),
                SettingsTile(
                    title: const Text("Add another Nextcloud instance"),
                    leading: const Icon(
                      EvaIcons.personAdd,
                    )),
                SettingsTile(
                    title: const Text("Logout"),
                    onPressed: (context) => controller.logout(),
                    leading: const Icon(
                      EvaIcons.logOut,
                    )),
              ]),
          SettingsSection(
            title: const Text('Common'),
            tiles: <SettingsTile>[
              SettingsTile(
                leading: const Icon(EvaIcons.trash2),
                title: const Text('Clear cache'),
                onPressed: (context) => controller.clearCache(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
