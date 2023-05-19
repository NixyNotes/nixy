import 'package:auto_route/auto_route.dart';
import 'package:nextcloudnotes/core/di/di.dart';
import 'package:nextcloudnotes/core/router/router.gr.dart';
import 'package:nextcloudnotes/core/storage/auth.storage.dart';

class AuthGuard extends AutoRouteGuard {
  final authStorage = getIt<AuthStorage>();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final hasUsers = await authStorage.hasUser();

    if (hasUsers > 0) {
      // if user is authenticated we continue
      resolver.next(true);
    } else {
      // we redirect the user to our login page
      router.push(const LoginRoute());
    }
  }
}
