import 'dart:io';

/// The function checks for internet access by attempting to lookup the IP address of a given website.
///
/// Returns:
///   a `Future<bool>` which indicates whether there is internet access or not. If there is internet
/// access, it returns `true`, otherwise it returns `false`.
Future<bool> checkForInternetAccess() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }

    return false;
  } on SocketException catch (_) {
    return false;
  }
}
