import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:nextcloudnotes/core/models/user.model.dart';
import 'package:nextcloudnotes/core/storage/auth.storage.dart';

part 'auth.controller.g.dart';

@lazySingleton
class AuthController = _AuthControllerBase with _$AuthController;

enum LoginState { loggedIn, none }

abstract class _AuthControllerBase with Store {
  _AuthControllerBase(this._authStorage);

  final AuthStorage _authStorage;

  @observable
  Observable<LoginState> loginState = Observable(LoginState.none);

  @observable
  ObservableList<List<User>> availableAccounts = ObservableList();

  @observable
  Observable<User?> currentAccount = Observable(null);

  @action
  Future<void> initState() async {
    final hasUsers = await _authStorage.hasUsers();

    if (hasUsers) {
      final users = await _authStorage.getUsers();

      loginState.value = LoginState.loggedIn;
      currentAccount.value = users.first;
    }
  }

  @action
  Future<void> logout() async {
    if (currentAccount.value != null) {
      await _authStorage.deleteAccount(currentAccount.value!.id);
    }
    loginState.value = LoginState.none;
    currentAccount.value = null;
  }

  @action
  setLoginState(LoginState lState) {
    loginState.value = lState;
  }
}
