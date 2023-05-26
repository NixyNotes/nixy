import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:nextcloudnotes/components/modal_sheet_menu.component.dart';
import 'package:nextcloudnotes/core/router/router.gr.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';
import 'package:nextcloudnotes/core/shared/components/scaffold.component.dart';
import 'package:nextcloudnotes/features/settings/controllers/settings_view.controller.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:settings_ui/settings_ui.dart';

class CustomPopupMenuSettingsTile extends AbstractSettingsTile {
  const CustomPopupMenuSettingsTile(
      {super.key, required this.title, required this.leading});

  final Widget title;
  final Widget leading;

  @override
  Widget build(BuildContext context) {
    final controller = getIt<SettingsViewController>();

    List<PullDownMenuItem> availableAccountsToWidget() {
      return controller.availableAccounts
          .map((element) => PullDownMenuItem(
              onTap: () {
                controller.switchAccount(element);
              },
              title: element.server ?? "OOPS"))
          .toList();
    }

    if (Platform.isIOS) {
      return Observer(builder: (_) {
        return PullDownButton(
          itemBuilder: (context) => availableAccountsToWidget(),
          buttonBuilder: (context, showMenu) {
            return SettingsTile.navigation(
              title: title,
              leading: leading,
              onPressed: (context) => showMenu(),
              enabled: controller.availableAccounts.isNotEmpty,
            );
          },
        );
      });
    }

    return SettingsTile.navigation(
      title: title,
      leading: leading,
      enabled: controller.availableAccounts.isNotEmpty,
      onPressed: (context) {
        showPlatformModalSheet(
          context: context,
          builder: (_) {
            return Material(
                child: ModalSheetMenu(items: availableAccountsToWidget()));
          },
        );
      },
    );
  }
}

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
                CustomPopupMenuSettingsTile(
                    title: Observer(
                      builder: (_) {
                        return Text(controller.currentAccount?.server ?? "");
                      },
                    ),
                    leading: const Icon(
                      EvaIcons.activity,
                    )),
                SettingsTile.navigation(
                  title: const Text("Add another Nextcloud instance"),
                  leading: const Icon(
                    EvaIcons.personAdd,
                  ),
                  onPressed: (context) => context.router.navigate(LoginRoute()),
                ),
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
