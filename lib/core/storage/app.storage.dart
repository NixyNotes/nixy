import 'package:injectable/injectable.dart';
import 'package:nextcloudnotes/core/config.dart';
import 'package:nextcloudnotes/models/app_storage.model.dart';
import 'package:nextcloudnotes/models/list_view.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The `AppStorage` class provides a method to save app settings using `SharedPreferences`.
@lazySingleton
class AppStorage {
  /// This code defines a private asynchronous getter method `_autoSaveDelay` that retrieves the auto-save
  /// timer duration from the app's shared preferences using the `SharedPreferences` package. If the
  /// duration is found in the shared preferences, it is parsed into minutes and seconds and returned as a
  /// `Duration` object. If the duration is not found, the method returns `null`.
  Future<Duration?> get autoSaveDelay async {
    final prefs = await SharedPreferences.getInstance();
    final duration = prefs.getString(AppStorageKeys.autoSaveDelay.name);

    if (duration != null) {
      final parse = duration.split(':');
      final minutes = int.parse(parse[0]);
      final seconds = int.parse(parse[1]);

      return Duration(minutes: minutes, seconds: seconds);
    }
    return null;
  }

  /// This code defines a getter method `homeListView` that retrieves the saved home list view preference
  /// from the app's shared preferences using the `SharedPreferences` package. If the preference is found
  /// in the shared preferences, it is parsed into a `HomeListView` object and returned. If the preference
  /// is not found, the method returns the default home list view.

  Future<HomeListView> get homeListView async {
    final prefs = await SharedPreferences.getInstance();
    final listView = prefs.getString(AppStorageKeys.listView.name);

    return HomeListView.values.byName(listView ?? DEFAULT_HOME_VIEW.name);
  }

  /// This function saves the auto-save timer duration in minutes and seconds to the device's shared
  /// preferences.
  ///
  /// Args:
  ///   duration (Duration): The `duration` parameter is a `Duration` object representing the amount of
  /// time to be saved for the auto-save timer. It is used to calculate the number of minutes and seconds
  /// to be stored in the app's shared preferences.
  Future<void> saveAutoSaveTimer(Duration duration) async {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    final durationToString = '$minutes:$seconds';

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(AppStorageKeys.autoSaveDelay.name, durationToString);
  }

  /// This function saves the name of a HomeListView object to SharedPreferences.
  ///
  /// Args:
  ///   view (HomeListView): The parameter "view" is of type HomeListView, which is likely a custom class
  /// representing a specific view or layout for a home screen. It is being used to save the name of the
  /// view as a string in the app's shared preferences using the Flutter package "SharedPreferences".
  Future<void> saveListViewPreference(HomeListView view) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(AppStorageKeys.listView.name, view.name);
  }

  /// The function clears all data stored in the shared preferences.
  Future<void> clearStorage() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();
  }
}
