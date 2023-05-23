import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:nextcloudnotes/core/controllers/auth.controller.dart';

@LazySingleton()
class BaseUrlInterceptor extends Interceptor {
  final AuthController authController;
  BaseUrlInterceptor(this.authController);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final isLoggedIn = authController.loginState.value == LoginState.loggedIn;

    if (isLoggedIn) {
      authController.currentAccount.observe((value) {
        final account = authController.currentAccount.value;

        if (value.newValue != null) {
          options.baseUrl = account!.server!;
        }
      });

      final account = authController.currentAccount.value;
      options.baseUrl = account!.server!;
    }

    return super.onRequest(options, handler);
  }
}
