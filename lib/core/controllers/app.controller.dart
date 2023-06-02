// ignore_for_file: use_setters_to_change_properties

import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:nextcloudnotes/core/storage/app.storage.dart';

part 'app.controller.g.dart';

@lazySingleton

/// Application settings that user can change inside the application
class AppController = _AppControllerBase with _$AppController;

abstract class _AppControllerBase with Store {
  _AppControllerBase(this._appStorage);

  final AppStorage _appStorage;

  @observable
  Observable<Duration> autoSaveTimer = Observable(const Duration(seconds: 10));

  Future<void> init() async {
    await _loadAutoSaveSettings();
  }

  @action
  Future<void> setAutoSaveTimer(Duration duration) async {
    autoSaveTimer.value = duration;

    await _appStorage.saveAutoSaveTimer(duration);
  }

  @action
  Future<void> _loadAutoSaveSettings() async {
    final autoSaveDelay = await _appStorage.autoSaveDelay;

    if (autoSaveDelay != null) {
      autoSaveTimer.value = autoSaveDelay;
    }
  }

  Future<void> resetCache() async {
    await _appStorage.clearStorage();
  }
}
