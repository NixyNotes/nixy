import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:nextcloudnotes/core/controllers/auth.controller.dart';

@LazySingleton()
class AuthInterceptor extends Interceptor {
  final AuthController authController;
  AuthInterceptor(this.authController);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final isLoggedIn = authController.loginState.value == LoginState.loggedIn;

    if (isLoggedIn) {
      authController.currentAccount.observe((value) {
        if (value.newValue != null) {
          options.headers["Authorization"] = "Bearer ${value.newValue?.token}";
        }
      });

      final account = authController.currentAccount.value;
      options.headers["Authorization"] = "Basic ${account?.token}";
    }

    options.headers["OCS-APIRequest"] = "true";
    options.headers["Accept"] = "application/json";

    return super.onRequest(options, handler);
  }
}
