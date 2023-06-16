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
    required this.items,
    this.isEnabled = true,
    super.key,
  });

  /// `final Widget title;` is declaring a final variable `title` of type `Widget`. This variable is used
  /// in the `CustomPopupMenuSettingsTile` widget to display the title of the tile.
  final Widget title;

  /// `final Widget leading;` is declaring a final variable `leading` of type `Widget`. This variable is
  /// used in the `CustomPopupMenuSettingsTile` widget to display an icon or image on the left side of the
  /// tile.
  final Widget leading;

  /// The `final List<PullDownMenuItem> items;` is declaring a final variable `items` of type
  /// `List<PullDownMenuItem>`. This variable is not used in the code snippet provided and may have been
  /// intended for future use or as a placeholder.
  final List<PullDownMenuItem> items;

  /// The `final bool? isEnabled;` is declaring a nullable final variable `isEnabled` of type `bool`. It
  /// is used in the `CustomPopupMenuSettingsTile` widget to determine if the tile is enabled or disabled.
  /// If `isEnabled` is `true` (or not provided), the tile is enabled and can be interacted with. If
  /// `isEnabled` is `false`, the tile is disabled and cannot be interacted with.
  final bool? isEnabled;

  @override
  Widget build(BuildContext context) {
    final controller = getIt<SettingsViewController>();

    if (Platform.isIOS) {
      return Observer(
        builder: (_) {
          return PullDownButton(
            itemBuilder: (context) => items,
            buttonBuilder: (context, showMenu) {
              return SettingsTile.navigation(
                title: title,
                leading: leading,
                onPressed: (context) => showMenu(),
                enabled: isEnabled ?? true,
              );
            },
          );
        },
      );
    }

    return SettingsTile.navigation(
      title: title,
      leading: leading,
      enabled: isEnabled ?? true,
      onPressed: (context) {
        showPlatformModalSheet<void>(
          context: context,
          builder: (_) {
            return Material(
              child: ModalSheetMenu(items: items),
            );
          },
        );
      },
    );
  }
}
