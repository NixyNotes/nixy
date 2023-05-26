import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:nextcloudnotes/core/controllers/auth.controller.dart';
import 'package:nextcloudnotes/core/scheme/user.scheme.dart';
import 'package:nextcloudnotes/core/services/toast.service.dart';
import 'package:nextcloudnotes/core/storage/note.storage.dart';
import 'package:nextcloudnotes/core/storage/offline_queue.storage.dart';

part 'settings_view.controller.g.dart';

disposeSettingsViewController(SettingsViewController instance) {}

@LazySingleton(dispose: disposeSettingsViewController)
class SettingsViewController = _SettingsViewControllerBase
    with _$SettingsViewController;

abstract class _SettingsViewControllerBase with Store {
  _SettingsViewControllerBase(this._authController, this._noteStorage,
      this._offlineQueueStorage, this._toastService);

  final AuthController _authController;
  final NoteStorage _noteStorage;
  final OfflineQueueStorage _offlineQueueStorage;
  final ToastService _toastService;

  @computed
  User? get currentAccount => _authController.currentAccount.value;

  @computed
  ObservableList<User> get availableAccounts =>
      _authController.availableAccounts;

  clearCache({bool? showToast = true}) async {
    _noteStorage.deleteAll();
    _offlineQueueStorage.deleteAll();

    if (showToast != null && showToast) {
      _toastService.showTextToast("Done", type: ToastType.success);
    }
  }

  switchAccount(User user) {
    _authController.login(user);
    clearCache(showToast: false);

    _toastService.showTextToast("Switched to instance: ${user.server}",
        type: ToastType.success);
  }

  logout() async {
    await _authController.logout();
  }
}
