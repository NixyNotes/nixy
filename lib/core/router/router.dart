import 'package:auto_route/auto_route.dart';
import 'package:nextcloudnotes/core/router/guards/auth.guard.dart';
import 'package:nextcloudnotes/core/router/router.gr.dart';
import 'package:nextcloudnotes/core/router/router_meta.dart';

@AutoRouterConfig(replaceInRouteName: 'View,Route')
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: AppRoute.page,
          initial: true,
          children: [
            AutoRoute(
              page: RouterMeta.Home.page,
              title: RouterMeta.Home.titleToWidget(),
              guards: [AuthGuard()],
              initial: true,
            ),
            AutoRoute(
              page: NoteRoute.page,
              guards: [AuthGuard()],
              fullscreenDialog: true,
            ),
            AutoRoute(
              page: RouterMeta.Login.page,
              title: RouterMeta.Login.titleToWidget(),
            ),
            AutoRoute(
                page: RouterMeta.ConnectToServer.page,
                title: RouterMeta.ConnectToServer.titleToWidget(),
                fullscreenDialog: true),
          ],
        )
      ];
}
