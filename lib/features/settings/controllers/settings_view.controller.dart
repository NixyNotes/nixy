import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:nextcloudnotes/core/controllers/auth.controller.dart';
import 'package:nextcloudnotes/core/scheme/user.scheme.dart';
import 'package:nextcloudnotes/core/services/toast.service.dart';
import 'package:nextcloudnotes/core/storage/note.storage.dart';
import 'package:nextcloudnotes/core/storage/offline_queue.storage.dart';

part 'settings_view.controller.g.dart';

/// The function disposes a SettingsViewController instance.
///
/// Args:
///   instance (SettingsViewController): The parameter "instance" is of type "SettingsViewController",
/// which is the class name of a specific view controller in an iOS app. This parameter is used in the
/// method "disposeSettingsViewController" to reference an instance of the SettingsViewController class
/// that needs to be disposed of or released from memory.
void disposeSettingsViewController(SettingsViewController instance) {}

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
  );

  final AuthController _authController;
  final NoteStorage _noteStorage;
  final OfflineQueueStorage _offlineQueueStorage;
  final ToastService _toastService;

  @computed
  User? get currentAccount => _authController.currentAccount.value;

  @computed
  ObservableList<User> get availableAccounts =>
      _authController.availableAccounts;

  Future<void> clearCache({bool? showToast = true}) async {
    _noteStorage.deleteAll();
    _offlineQueueStorage.deleteAll();

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
}
