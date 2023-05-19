import 'package:auto_route/auto_route.dart';
import 'package:nextcloudnotes/core/router/guards/auth.guard.dart';
import 'package:nextcloudnotes/core/router/router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'View,Route')
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, guards: [AuthGuard()], initial: true),
        AutoRoute(
          page: LoginRoute.page,
          title: (context, data) => "Login to a instance",
        ),
        AutoRoute(
            page: ConnectToServerRoute.page,
            title: (context, data) => "Nextcloud",
            fullscreenDialog: true),
      ];
}
