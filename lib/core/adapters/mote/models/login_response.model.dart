import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response.model.freezed.dart';
part 'login_response.model.g.dart';

@freezed
class MoteLoginResponse with _$MoteLoginResponse {
  const factory MoteLoginResponse({
    @JsonKey(name: 'access_token') required String accessToken,
    required MoteUser user,
  }) = _LoginResponse;

  factory MoteLoginResponse.fromJson(Map<String, dynamic> json) =>
      _$MoteLoginResponseFromJson(json);
}

@freezed
class MoteUser with _$MoteUser {
  const factory MoteUser({
    required int id,
    required String email,
    required String username,
    @JsonKey(name: 'profile_picture') required dynamic profilePicture,
  }) = _MoteUser;

  factory MoteUser.fromJson(Map<String, dynamic> json) =>
      _$MoteUserFromJson(json);
}
