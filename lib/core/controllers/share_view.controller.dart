import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:nextcloudnotes/core/router/router_meta.dart';

///
void disposeShareViewController(ShareViewController instance) {
  instance.dispose();
}

@LazySingleton(dispose: disposeShareViewController)

/// The `ShareViewController` class handles sharing media files and text from outside the app in
/// Flutter, allowing users to create new notes based on the shared content.
class ShareViewController {
  late final BuildContext _context;

  late final StreamSubscription<List<SharedFile>> _intentDataStreamSubscription;

  /// The `init` function initializes the sharing intent functionality for iOS and Android platforms,
  /// allowing the app to receive and handle shared images from outside the app while it is on foreground
  /// or closed.
  ///
  /// Args:
  ///   buildContext (BuildContext): The `buildContext` parameter is of type `BuildContext` and represents
  /// the context in which the widget is built. It is typically used to access the properties and methods
  /// of the widget's parent or ancestor widgets.
  Future<void> init(BuildContext buildContext) async {
    _context = buildContext;

    if (Platform.isIOS || Platform.isAndroid) {
      // For sharing images coming from outside the app while the app is on foreground
      _intentDataStreamSubscription =
          FlutterSharingIntent.instance.getMediaStream().listen(
        _main,
        onError: (err) {
          print('getIntentDataStream error: $err');
        },
      );

      // For sharing images coming from outside the app while the app is closed
      await FlutterSharingIntent.instance.getInitialSharing().then(_main);
    }
  }

  Future<void> _main(List<SharedFile> value) async {
    for (final element in value) {
      final isTextOrUrl = element.type == SharedMediaType.TEXT ||
          element.type == SharedMediaType.URL;

      if (isTextOrUrl && element.value != null) {
        await _context.pushNamed(
          RouterMeta.NewNote.name,
          queryParameters: {'title': element.value, 'content': element.value},
        );
      } else {
        print('Not supported');
      }
    }
  }

  ///
  void dispose() {
    _intentDataStreamSubscription.cancel();
  }
}
