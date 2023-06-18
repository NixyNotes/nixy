// ignore_for_file: use_setters_to_change_properties

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:nextcloudnotes/core/controllers/auth.controller.dart';
import 'package:nextcloudnotes/core/services/offline.service.dart';
import 'package:nextcloudnotes/core/storage/app.storage.dart';
import 'package:nextcloudnotes/models/list_view.model.dart';

part 'app.controller.g.dart';

@lazySingleton

/// Application settings that user can change inside the application
class AppController = _AppControllerBase with _$AppController;

abstract class _AppControllerBase extends ChangeNotifier with Store {
  _AppControllerBase(
    this._appStorage,
    this._authController,
    this._offlineService,
  );

  final AppStorage _appStorage;
  final AuthController _authController;
  final OfflineService _offlineService;

  @observable
  Observable<Duration> autoSaveTimer = Observable(const Duration(seconds: 10));

  @observable
  Observable<HomeListView> homeNotesView = Observable(HomeListView.list);

  @observable
  Observable<bool?> showIntroductionScreen = Observable(true);

  bool isInitialized = false;

  Future<void> init() async {
    await _authController.initState();
    await _offlineService.checkForNetworkConditions();
    await _loadAutoSaveSettings();

    isInitialized = true;
    notifyListeners();
  }

  @action
  Future<void> setAutoSaveTimer(Duration duration) async {
    autoSaveTimer.value = duration;

    await _appStorage.saveAutoSaveTimer(duration);
  }

  @action
  Future<void> setHomeNotesView(HomeListView view) async {
    homeNotesView.value = view;
    await _appStorage.saveListViewPreference(view);
  }

  @action
  Future<void> setShowIntroductionScreen({required bool value}) async {
    showIntroductionScreen.value = value;
    await _appStorage.saveShowIntroductionScreen(value: value);

    notifyListeners();
  }

  @action
  Future<void> _loadAutoSaveSettings() async {
    final autoSaveDelay = await _appStorage.autoSaveDelay;
    final homeListView = await _appStorage.homeListView;
    final showIntroductionScreenValue =
        await _appStorage.showIntroductionScreen;

    homeNotesView.value = homeListView;
    showIntroductionScreen.value = showIntroductionScreenValue;

    if (autoSaveDelay != null) {
      autoSaveTimer.value = autoSaveDelay;
    }
  }

  Future<void> resetCache() async {
    await _appStorage.clearStorage();
  }
}
