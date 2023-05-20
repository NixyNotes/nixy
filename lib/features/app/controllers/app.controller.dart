import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:nextcloudnotes/core/controllers/auth.controller.dart';
import 'package:nextcloudnotes/core/controllers/queue.controller.dart';

part 'app.controller.g.dart';

@lazySingleton
class AppViewController = _AppViewControllerBase with _$AppViewController;

abstract class _AppViewControllerBase with Store {
  _AppViewControllerBase(this._authController, this._queueController);

  final AuthController _authController;
  final QueueController _queueController;

  @action
  Future<void> initState() async {
    await _authController.initState();
    _queueController.init();
  }
}
