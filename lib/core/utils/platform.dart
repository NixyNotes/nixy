import 'dart:io';

/// The function checks if the current platform is a desktop platform.
///
/// Returns:
///   A boolean value indicating whether the current platform is a desktop platform or not. If the
/// current platform is Linux, macOS, or Windows, the function will return true. Otherwise, it will
/// return false.
bool isDesktopPlatform() {
  if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
    return true;
  }

  return false;
}
