import 'package:auto_route/auto_route.dart';
import 'package:nextcloudnotes/core/controllers/auth.controller.dart';
import 'package:nextcloudnotes/core/router/router.gr.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';

/// The AuthGuard class is an AutoRouteGuard that checks if the user is logged in and redirects them to
/// the login page if they are not.
class AuthGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final authStorage = getIt<AuthController>();

    if (authStorage.isLoggedIn) {
      return resolver.next();
    } else {
      await router.push(
        LoginRoute(
          onResult: ({bool? success}) {
            router.replaceAll([HomeRoute()]);
          },
        ),
      );
    }
  }
}
