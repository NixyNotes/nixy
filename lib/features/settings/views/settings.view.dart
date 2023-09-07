import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:nextcloudnotes/components/autosave_time_dialog.component.dart';
import 'package:nextcloudnotes/core/router/router_meta.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';
import 'package:nextcloudnotes/core/shared/components/scaffold.component.dart';
import 'package:nextcloudnotes/features/settings/controllers/settings_view.controller.dart';
import 'package:nextcloudnotes/features/settings/views/components/custom_settings_tile.component.dart';
import 'package:nextcloudnotes/models/list_view.model.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:settings_ui/settings_ui.dart';

/// This is a settings view class that displays various settings options and allows the user to navigate
/// to other views.
class SettingsView extends StatefulWidget {
  /// This is a settings view class that displays various settings options and allows the user to navigate
  /// to other views.
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final controller = getIt<SettingsViewController>();
  final List<AbstractSettingsSection> authSection = [];
  late Dispose accountsAvailableObservableDisposer;

  List<PullDownMenuItem> get availableAccounts {
    return controller.authController.availableAccounts
        .map(
          (element) => PullDownMenuItem(
            onTap: () => controller.switchAccount(element),
            title: '${element.server} - ${element.adapter.name}',
            enabled: element.isCurrent ? false : true,
          ),
        )
        .toList();
  }

  List<PullDownMenuItem> get homeListViews {
    return HomeListView.values
        .map(
          (element) => PullDownMenuItem(
            onTap: () => controller.saveHomeNotesView(element),
            title: element.title,
          ),
        )
        .toList();
  }

  @override
  void initState() {
    super.initState();
    controller.init();

    accountsAvailableObservableDisposer =
        controller.authController.availableAccounts.observe(
      (value) {
        print('calistim');

        if (value.list.isNotEmpty) {
          setState(() {
            authSection.add(
              authSettingsSection(),
            );
          });
        } else {
          setState(() {
            authSection.add(
              nonAuthSettingsSection(),
            );
          });
        }
      },
      fireImmediately: true,
    );
  }

  SettingsSection nonAuthSettingsSection() {
    return SettingsSection(
      title: const Text('Providers'),
      tiles: [
        SettingsTile.navigation(
          title: const Text('Add provider'),
          leading: const Icon(
            EvaIcons.personAdd,
          ),
          onPressed: (context) =>
              context.pushNamed(RouterMeta.AddNewAccount.name),
        ),
      ],
    );
  }

  SettingsSection authSettingsSection() {
    return SettingsSection(
      title: const Text('Providers'),
      tiles: [
        CustomPopupMenuSettingsTile(
          title: Observer(
            builder: (_) {
              return Text(
                '${controller.currentAccount!.server} - ${controller.currentAccount!.adapter.name}' ??
                    '',
              );
            },
          ),
          leading: const Icon(
            EvaIcons.activity,
          ),
          items: controller.authController.availableAccounts
              .map(
                (element) => PullDownMenuItem(
                  onTap: () => controller.switchAccount(element),
                  title:
                      '${element.server} - ${element.adapter.name} - ${element.isCurrent}',
                  enabled: element.isCurrent ? false : true,
                ),
              )
              .toList(),
        ),
        SettingsTile.navigation(
          title: const Text('Add another provider'),
          leading: const Icon(
            EvaIcons.personAdd,
          ),
          onPressed: (context) =>
              context.pushNamed(RouterMeta.AddNewAccount.name),
        ),
        SettingsTile(
          title: const Text('Logout'),
          onPressed: (context) => controller.logout(),
          leading: const Icon(
            EvaIcons.logOut,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    getIt.resetLazySingleton<SettingsViewController>();
    accountsAvailableObservableDisposer();
    super.dispose();
  }

  Future<void> showAutoSaveDialog() async {
    await showDialog<void>(
      context: context,
      builder: (_) => AutoSaveTimePickerDialog(
        minutesTextController: controller.autoSaveMinutesController,
        secondsTextController: controller.autoSaveSecondsController,
        onTapDone: controller.saveAutoSaveDetails,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      innerPadding: false,
      body: Observer(
        builder: (context) {
          return SettingsList(
            sections: [
              ...authSection,
              SettingsSection(
                title: const Text('Common'),
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                    title: const Text('Auto save delay'),
                    value: Observer(
                      builder: (_) {
                        return Text(
                          controller.currentAutoSaveDelayValueAsString,
                        );
                      },
                    ),
                    onPressed: (_) => showAutoSaveDialog(),
                    leading: const Icon(
                      EvaIcons.clockOutline,
                    ),
                  ),
                  SettingsTile(
                    leading: const Icon(EvaIcons.trash2),
                    title: const Text('Clear cache'),
                    onPressed: (context) => controller.clearCache(),
                  ),
                ],
              ),
              SettingsSection(
                title: const Text('Theming'),
                tiles: [
                  CustomPopupMenuSettingsTile(
                    title: const Text('Home notes view'),
                    leading: const Icon(EvaIcons.browserOutline),
                    items: homeListViews,
                    value: Observer(
                      builder: (_) {
                        return Text(controller.currentHomeListView.title);
                      },
                    ),
                  )
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
