import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:nextcloudnotes/components/modal_sheet_menu.component.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';
import 'package:nextcloudnotes/features/settings/controllers/settings_view.controller.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:settings_ui/settings_ui.dart';

/// The `CustomPopupMenuSettingsTile` class is a widget that displays a dropdown menu of available
/// accounts for the user to select from.
class CustomPopupMenuSettingsTile extends AbstractSettingsTile {
  /// The `CustomPopupMenuSettingsTile` class is a widget that displays a dropdown menu of available
  /// accounts for the user to select from.
  const CustomPopupMenuSettingsTile({
    required this.title,
    required this.leading,
    super.key,
  });

  /// `final Widget title;` is declaring a final variable `title` of type `Widget`. This variable is used
  /// in the `CustomPopupMenuSettingsTile` widget to display the title of the tile.
  final Widget title;

  /// `final Widget leading;` is declaring a final variable `leading` of type `Widget`. This variable is
  /// used in the `CustomPopupMenuSettingsTile` widget to display an icon or image on the left side of the
  /// tile.
  final Widget leading;

  @override
  Widget build(BuildContext context) {
    final controller = getIt<SettingsViewController>();

    List<PullDownMenuItem> availableAccountsToWidget() {
      return controller.availableAccounts
          .map(
            (element) => PullDownMenuItem(
              onTap: () {
                controller.switchAccount(element);
              },
              title: element.server,
            ),
          )
          .toList();
    }

    if (Platform.isIOS) {
      return Observer(
        builder: (_) {
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
        },
      );
    }

    return SettingsTile.navigation(
      title: title,
      leading: leading,
      enabled: controller.availableAccounts.isNotEmpty,
      onPressed: (context) {
        showPlatformModalSheet<void>(
          context: context,
          builder: (_) {
            return Material(
              child: ModalSheetMenu(items: availableAccountsToWidget()),
            );
          },
        );
      },
    );
  }
}
