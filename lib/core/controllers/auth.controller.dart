import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:nextcloudnotes/core/scheme/user.scheme.dart';
import 'package:nextcloudnotes/core/storage/auth.storage.dart';

part 'auth.controller.g.dart';

@lazySingleton

/// Authentication controller for app
class AuthController = _AuthControllerBase with _$AuthController;

/// `enum LoginState { loggedIn, none }` is defining an enumeration type with two possible values:
/// `loggedIn` and `none`. This enum is used in the `_AuthControllerBase` class to keep track of the
/// current login state of the user. The `loginState` observable is of type `Observable<LoginState>` and
/// can be observed and modified using MobX. The `isLoggedIn` computed property returns `true` if the
/// `loginState` is `loggedIn`.
// ignore: public_member_api_docs
enum LoginState { loggedIn, none }

abstract class _AuthControllerBase extends ChangeNotifier with Store {
  _AuthControllerBase(this._authStorage);

  final AuthStorage _authStorage;

  late ReactionDisposer loginWatcherDisposer;

  @observable
  Observable<LoginState> loginState = Observable(LoginState.none);

  @observable
  ObservableList<User> availableAccounts = ObservableList();

  @observable
  Observable<User?> currentAccount = Observable(null);

  @computed
  bool get isLoggedIn => loginState.value == LoginState.loggedIn;

  @action
  Future<void> initState() async {
    final hasUsers = await _authStorage.hasUsers();

    if (hasUsers) {
      // App initiliazed.
      final users = await _authStorage.getUsers();

      loginState.value = LoginState.loggedIn;
      currentAccount.value = users.firstWhere((element) => element.isCurrent);

      users.removeWhere((element) => element.id == currentAccount.value!.id);
      availableAccounts = ObservableList.of(users);
      notifyListeners();
    }

    currentAccount.observe((_) async {
      // Check for current account, if changes remove current account from
      // availableAccounts.
      final users = await _authStorage.getUsers();

      users.removeWhere((element) => element.id == currentAccount.value!.id);

      availableAccounts = ObservableList.of(users);
    });
  }

  @action
  void login(User user) {
    final modifiedUser = user..isCurrent = true;
    _authStorage.saveUser(modifiedUser);
    currentAccount.value = user;
    loginState.value = LoginState.loggedIn;
    notifyListeners();
  }

  @action
  Future<void> logout() async {
    if (currentAccount.value != null) {
      await _authStorage.deleteAccount(currentAccount.value!.id);
    }
    final users = await _authStorage.getUsers();

    if (users.isNotEmpty) {
      currentAccount.value = users.last;
    } else {
      loginState.value = LoginState.none;
      currentAccount.value = null;
      availableAccounts.clear();
    }
    notifyListeners();
  }

  @action
  // ignore: use_setters_to_change_properties
  void setLoginState(LoginState lState) {
    loginState.value = lState;
  }
}
