import 'package:auto_route/auto_route.dart';
import 'package:nextcloudnotes/core/controllers/auth.controller.dart';
import 'package:nextcloudnotes/core/router/router.gr.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final authStorage = getIt<AuthController>();

    if (authStorage.isLoggedIn) {
      return resolver.next();
    } else {
      router.push(LoginRoute(
        onResult: (_) {
          router.replaceAll([const HomeRoute()]);
        },
      ));
    }
  }
}
