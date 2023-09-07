import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:nextcloudnotes/core/controllers/auth.controller.dart';

/// The `BaseUrlInterceptor` class is a Dart class that intercepts HTTP requests and sets the base URL
/// based on the current user's account server.
@LazySingleton()
class BaseUrlInterceptor extends Interceptor {
  /// The `BaseUrlInterceptor` class is a Dart class that intercepts HTTP requests and sets the base URL
  /// based on the current user's account server.
  BaseUrlInterceptor(this._authController);
  final AuthController _authController;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isLoggedIn = _authController.loginState.value == LoginState.loggedIn;

    if (isLoggedIn) {
      _authController.currentAccount.observe((value) {
        final account = _authController.currentAccount.value;

        if (value.newValue != null) {
          options.baseUrl = account!.server;
        }
      });

      final account = _authController.currentAccount.value;
      options.baseUrl = account!.server;
    }

    return super.onRequest(options, handler);
  }
}
