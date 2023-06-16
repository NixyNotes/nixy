import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:nextcloudnotes/core/controllers/app.controller.dart';
import 'package:nextcloudnotes/core/controllers/auth.controller.dart';
import 'package:nextcloudnotes/core/scheme/user.scheme.dart';
import 'package:nextcloudnotes/core/services/toast.service.dart';
import 'package:nextcloudnotes/core/storage/note.storage.dart';
import 'package:nextcloudnotes/core/storage/offline_queue.storage.dart';
import 'package:nextcloudnotes/models/list_view.model.dart';

part 'settings_view.controller.g.dart';

/// The function disposes a SettingsViewController instance.
///
/// Args:
///   instance (SettingsViewController): The parameter "instance" is of type "SettingsViewController",
/// which is the class name of a specific view controller in an iOS app. This parameter is used in the
/// method "disposeSettingsViewController" to reference an instance of the SettingsViewController class
/// that needs to be disposed of or released from memory.
void disposeSettingsViewController(SettingsViewController instance) {
  instance.dispose();
}

@LazySingleton(dispose: disposeSettingsViewController)

/// Settings view controoler
class SettingsViewController = _SettingsViewControllerBase
    with _$SettingsViewController;

abstract class _SettingsViewControllerBase with Store {
  _SettingsViewControllerBase(
    this._authController,
    this._noteStorage,
    this._offlineQueueStorage,
    this._toastService,
    this._appController,
  );

  final AuthController _authController;
  final NoteStorage _noteStorage;
  final OfflineQueueStorage _offlineQueueStorage;
  final ToastService _toastService;
  final AppController _appController;

  final TextEditingController autoSaveMinutesController =
      TextEditingController();

  final TextEditingController autoSaveSecondsController =
      TextEditingController();

  @computed
  User? get currentAccount => _authController.currentAccount.value;

  @computed
  ObservableList<User> get availableAccounts =>
      _authController.availableAccounts;

  @computed
  String get currentAutoSaveDelayValueAsString {
    final value = _appController.autoSaveTimer.value;
    final minutes = value.inMinutes.remainder(60);
    final seconds = value.inSeconds.remainder(60);

    return '$minutes:$seconds';
  }

  void init() {
    autoSaveMinutesController.text =
        _appController.autoSaveTimer.value.inMinutes.remainder(60).toString();

    autoSaveSecondsController.text =
        _appController.autoSaveTimer.value.inSeconds.remainder(60).toString();
  }

  Future<void> clearCache({bool? showToast = true}) async {
    _noteStorage.deleteAll();
    _offlineQueueStorage.deleteAll();
    await _appController.resetCache();

    if (showToast != null && showToast) {
      _toastService.showTextToast('Done', type: ToastType.success);
    }
  }

  void switchAccount(User user) {
    _authController.login(user);
    clearCache(showToast: false);

    _toastService.showTextToast(
      'Switched to instance: ${user.server}',
      type: ToastType.success,
    );
  }

  Future<void> logout() async {
    await _authController.logout();
  }

  Future<void> saveAutoSaveDetails() async {
    final duration = Duration(
      minutes: int.tryParse(autoSaveMinutesController.text) ?? 0,
      seconds: int.tryParse(autoSaveSecondsController.text) ?? 10,
    );

    await _appController.setAutoSaveTimer(duration);
  }

  Future<void> saveHomeNotesView(HomeListView view) async {
    await _appController.setHomeNotesView(view);
    _toastService.showTextToast('Switched to ${view.title}');
  }

  void dispose() {
    autoSaveMinutesController.dispose();
    autoSaveSecondsController.dispose();
  }
}
