import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:nextcloudnotes/core/router/router.gr.dart';
import 'package:nextcloudnotes/core/scheme/user.scheme.dart';
import 'package:nextcloudnotes/core/storage/auth.storage.dart';

part 'auth.controller.g.dart';

@lazySingleton
class AuthController = _AuthControllerBase with _$AuthController;

enum LoginState { loggedIn, none }

abstract class _AuthControllerBase with Store {
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
  Future<void> initState(BuildContext context) async {
    final hasUsers = await _authStorage.hasUsers();

    if (hasUsers) {
      // App initiliazed.
      final users = await _authStorage.getUsers();

      loginState.value = LoginState.loggedIn;
      currentAccount.value = users.firstWhere((element) => element.isCurrent);

      users.removeWhere((element) => element.id == currentAccount.value!.id);
      availableAccounts = ObservableList.of(users);
    }

    currentAccount.observe((_) async {
      // Check for current account, if changes remove current account from
      // availableAccounts.
      final users = await _authStorage.getUsers();

      users.removeWhere((element) => element.id == currentAccount.value!.id);

      availableAccounts = ObservableList.of(users);
    });

    loginState.observe((
      p0,
    ) {
      // Router observer, if authenticated route to home.
      if (p0.newValue == LoginState.loggedIn) {
        context.router.replaceAll([const HomeRoute()]);
      } else {
        context.router.replaceAll([LoginRoute()]);
      }

      return;
    });
  }

  @action
  void login(User user) {
    final modifiedUser = user..isCurrent = true;
    _authStorage.saveUser(modifiedUser);
    currentAccount.value = user;
    loginState.value = LoginState.loggedIn;
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
  }

  @action
  setLoginState(LoginState lState) {
    loginState.value = lState;
  }
}
