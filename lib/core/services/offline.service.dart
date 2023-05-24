import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:nextcloudnotes/core/utils/network_checker.dart';

class OfflineData<T> {
  OfflineData(
      {required this.localData, this.remoteData, this.shouldMerge = false});

  final T localData;
  final T? remoteData;
  final bool? shouldMerge;
}

@lazySingleton
class OfflineService {
  Future<OfflineData<T>> fetch<T>(Future<T> Function() localStorage,
      Future<T> Function() remoteDataCall) async {
    final internetAccess = await checkForInternetAccess();
    final localData = await localStorage.call();
    bool shouldMerge = false;
    T? remoteData;

    if (internetAccess) {
      remoteData = await remoteDataCall.call();

      if (localData is List && remoteData is List) {
        shouldMerge = !listEquals(remoteData, localData);
      } else {
        shouldMerge = localData != remoteData;
      }
    }

    return OfflineData<T>(
      localData: localData,
      remoteData: remoteData,
      shouldMerge: shouldMerge,
    );
  }
}
