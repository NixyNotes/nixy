import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:nextcloudnotes/core/controllers/auth.controller.dart';

part 'settings_view.controller.g.dart';

class SettingsItem {
  SettingsItem(
      {required this.icon,
      required this.iconBgColor,
      required this.label,
      this.trailing,
      this.onTap});

  final IconData icon;
  final Color iconBgColor;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;
}

disposeSettingsViewController(SettingsViewController instance) {}

@LazySingleton(dispose: disposeSettingsViewController)
class SettingsViewController = _SettingsViewControllerBase
    with _$SettingsViewController;

abstract class _SettingsViewControllerBase with Store {
  _SettingsViewControllerBase(this._authController);

  final AuthController _authController;

  @observable
  List<SettingsItem> settings = ObservableList.of([
    SettingsItem(
      icon: EvaIcons.trash2Outline,
      iconBgColor: Colors.red.shade500,
      label: "Clear cache",
      onTap: () {},
    ),
    SettingsItem(
      icon: EvaIcons.logOut,
      iconBgColor: Colors.blue.shade500,
      label: "Logout",
      onTap: () {},
    )
  ]);

  @action
  void init(BuildContext context) {
    if (_authController.isLoggedIn) {
      final userSettings = SettingsItem(
          icon: EvaIcons.personOutline,
          iconBgColor: Colors.purple.shade500,
          label: _authController.currentAccount.value!.server!);

      settings.insert(0, userSettings);
    }
  }
}
