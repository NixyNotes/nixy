import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:nextcloudnotes/core/controllers/auth.controller.dart';

/// The AuthInterceptor class is a Dart class that intercepts HTTP requests and adds authorization
/// headers based on the user's login state and current account.
@LazySingleton()
class AuthInterceptor extends Interceptor {
  /// The AuthInterceptor class is a Dart class that intercepts HTTP requests and adds authorization
  /// headers based on the user's login state and current account.
  AuthInterceptor(this._authController);
  final AuthController _authController;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isLoggedIn = _authController.loginState.value == LoginState.loggedIn;

    if (isLoggedIn) {
      _authController.currentAccount.observe((value) {
        if (value.newValue != null) {
          options.headers['Authorization'] = 'Bearer ${value.newValue?.token}';
        }
      });

      final account = _authController.currentAccount.value;
      options.headers['Authorization'] = 'Basic ${account?.token}';
    }

    options.headers['OCS-APIRequest'] = 'true';
    options.headers['Accept'] = 'application/json';

    return super.onRequest(options, handler);
  }
}
