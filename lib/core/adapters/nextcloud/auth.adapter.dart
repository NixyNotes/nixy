import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:nextcloudnotes/core/adapters/auth.adapter.dart';
import 'package:nextcloudnotes/core/adapters/nextcloud/views/auth.view.dart';

@lazySingleton
class NextcloudAuthAdapter extends AuthAdapter {
  @override
  Future<bool> onLogin() {
    // TODO: implement onLogin
    throw UnimplementedError();
  }

  @override
  AuthAdapterType get type => AuthAdapterType.OAuth;

  @override
  Widget view() => const NextcloudAuthView();

  @override
  String get title => 'Nextcloud';

  @override
  String get serverUri => throw UnimplementedError();
}
