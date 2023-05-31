// ignore_for_file: public_member_api_docs

import 'package:freezed_annotation/freezed_annotation.dart';

part 'login.model.freezed.dart';
part 'login.model.g.dart';

@freezed
class Login with _$Login {
  const factory Login({
    required String server,
    required String loginName,
    required String appPassword,
  }) = _Login;

  factory Login.fromJson(Map<String, dynamic> json) => _$LoginFromJson(json);
}
