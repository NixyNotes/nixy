import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';
import 'package:nextcloudnotes/core/services/offline.service.dart';
import 'package:nextcloudnotes/core/services/toast.service.dart';

/// The `NetworkCheckerInterceptor` class is a Dart class that intercepts network requests and displays
/// a snackbar message if there is no internet access.
@lazySingleton
class NetworkCheckerInterceptor extends Interceptor {
  NetworkCheckerInterceptor(this._toastService);
  final ToastService _toastService;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final offlineService = getIt<OfflineService>();

    if (offlineService.hasInternetAccess) {
      return super.onRequest(options, handler);
    }

    _toastService.showTextToast('No internet access!', type: ToastType.error);

    return;
  }
}
