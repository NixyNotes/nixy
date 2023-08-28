import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:nextcloudnotes/core/adapters/auth.adapter.dart';
import 'package:nextcloudnotes/core/adapters/init_adapters.dart';

part 'login_view.controller.g.dart';

/// Login view controller'
@lazySingleton
class LoginViewController = _LoginViewControllerBase with _$LoginViewController;

abstract class _LoginViewControllerBase with Store {
  _LoginViewControllerBase(this._adapter);
  final Adapter _adapter;

  ObservableMap<String, AuthAdapter> authProviders = ObservableMap();

  @observable
  Observable<String> selectedAuthAdapter = Observable('');

  @action
  void init() {
    for (final adapter in _adapter.authAdapters) {
      final keyName = adapter.title.toLowerCase();
      authProviders.addAll({keyName: adapter});
    }
  }

  @action
  void onSelectAuthAdapter(String e) {
    selectedAuthAdapter.value = e;
  }
}
