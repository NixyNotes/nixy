// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthController on _AuthControllerBase, Store {
  late final _$loginStateAtom =
      Atom(name: '_AuthControllerBase.loginState', context: context);

  @override
  Observable<LoginState> get loginState {
    _$loginStateAtom.reportRead();
    return super.loginState;
  }

  @override
  set loginState(Observable<LoginState> value) {
    _$loginStateAtom.reportWrite(value, super.loginState, () {
      super.loginState = value;
    });
  }

  late final _$availableAccountsAtom =
      Atom(name: '_AuthControllerBase.availableAccounts', context: context);

  @override
  ObservableList<List<User>> get availableAccounts {
    _$availableAccountsAtom.reportRead();
    return super.availableAccounts;
  }

  @override
  set availableAccounts(ObservableList<List<User>> value) {
    _$availableAccountsAtom.reportWrite(value, super.availableAccounts, () {
      super.availableAccounts = value;
    });
  }

  late final _$currentAccountAtom =
      Atom(name: '_AuthControllerBase.currentAccount', context: context);

  @override
  Observable<User?> get currentAccount {
    _$currentAccountAtom.reportRead();
    return super.currentAccount;
  }

  @override
  set currentAccount(Observable<User?> value) {
    _$currentAccountAtom.reportWrite(value, super.currentAccount, () {
      super.currentAccount = value;
    });
  }

  late final _$initStateAsyncAction =
      AsyncAction('_AuthControllerBase.initState', context: context);

  @override
  Future<void> initState() {
    return _$initStateAsyncAction.run(() => super.initState());
  }

  late final _$_AuthControllerBaseActionController =
      ActionController(name: '_AuthControllerBase', context: context);

  @override
  dynamic setLoginState(LoginState lState) {
    final _$actionInfo = _$_AuthControllerBaseActionController.startAction(
        name: '_AuthControllerBase.setLoginState');
    try {
      return super.setLoginState(lState);
    } finally {
      _$_AuthControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loginState: ${loginState},
availableAccounts: ${availableAccounts},
currentAccount: ${currentAccount}
    ''';
  }
}
