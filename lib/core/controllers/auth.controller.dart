import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:nextcloudnotes/core/models/user.model.dart';
import 'package:nextcloudnotes/core/router/router.gr.dart';
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
  ObservableList<List<User>> availableAccounts = ObservableList();

  @observable
  Observable<User?> currentAccount = Observable(null);

  @computed
  bool get isLoggedIn => loginState.value == LoginState.loggedIn;

  @action
  Future<void> initState(BuildContext context) async {
    final hasUsers = await _authStorage.hasUsers();

    if (hasUsers) {
      final users = await _authStorage.getUsers();

      loginState.value = LoginState.loggedIn;
      currentAccount.value = users.first;
    }

    loginState.observe((
      p0,
    ) {
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
    _authStorage.saveUser(user);
    currentAccount.value = user;
    loginState.value = LoginState.loggedIn;
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
