import 'package:flutter/widgets.dart';

enum AuthAdapterType { OAuth, JWT }

abstract class AuthAdapter {
  AuthAdapterType get type;
  String get title;
  String get serverUri;

  Future<bool> onLogin();

  Widget view();
}
