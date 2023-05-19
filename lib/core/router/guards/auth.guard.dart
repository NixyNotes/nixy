import 'package:auto_route/auto_route.dart';
import 'package:nextcloudnotes/core/controllers/auth.controller.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';
import 'package:nextcloudnotes/core/router/router.gr.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final authStorage = getIt<AuthController>();

    final loginState = authStorage.loginState;

    if (loginState.value == LoginState.loggedIn) {
      return resolver.next(true);
    } else {
      router.replace(LoginRoute(
        onResult: (success) {
          resolver.next(success);
        },
      ));
    }

    loginState.observe((p0) {
      print("a");
    });
  }
}
