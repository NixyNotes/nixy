import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:nextcloudnotes/core/controllers/app.controller.dart';
import 'package:nextcloudnotes/core/router/router.dart';

@lazySingleton

/// The IntroductionScreenViewController class handles the onDone action and navigates to a secondary
/// route location while updating the app controller's showIntroductionScreen value.
class IntroductionScreenViewController {
  /// The IntroductionScreenViewController class handles the onDone action and navigates to a secondary
  /// route location while updating the app controller's showIntroductionScreen value.
  IntroductionScreenViewController(
    this._appRouter,
    this._appController,
  );

  final AppRouter _appRouter;
  final AppController _appController;

  /// This function sets a boolean value to false, updates a controller, and navigates to a specified
  /// route.
  Future<void> onDone() async {
    final routeLocation = _appRouter.secondaryRouteLocation;
    await _appController.setShowIntroductionScreen(value: false);
    _appController.showIntroductionScreen.value = false;
    await GoRouter.of(navigatorKey.currentContext!).push(routeLocation);
  }
}
