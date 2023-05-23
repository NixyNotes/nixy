// To parse this JSON data, do
//
//     final loginPoll = loginPollFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_poll.model.freezed.dart';
part 'login_poll.model.g.dart';

@freezed
class LoginPoll with _$LoginPoll {
  const factory LoginPoll({
    required Poll poll,
    required String login,
  }) = _LoginPoll;

  factory LoginPoll.fromJson(Map<String, dynamic> json) =>
      _$LoginPollFromJson(json);
}

@freezed
class Poll with _$Poll {
  const factory Poll({
    required String token,
    required String endpoint,
  }) = _Poll;

  factory Poll.fromJson(Map<String, dynamic> json) => _$PollFromJson(json);
}
