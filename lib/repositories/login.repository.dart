import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:nextcloudnotes/models/capabilities.model.dart';
import 'package:nextcloudnotes/models/login.model.dart';
import 'package:nextcloudnotes/models/login_poll.model.dart';

@lazySingleton
class LoginRepository {
  final Dio _dio = Dio();

  Future<LoginPoll> fetchLoginPoll(String serverUrl) async {
    final response = await _dio.post("$serverUrl/index.php/login/v2");

    return LoginPoll.fromJson(response.data);
  }

  Future<Login> fetchAppPassword(String serverUrl, String token) async {
    final response = await _dio
        .post("$serverUrl/index.php/login/v2/poll", data: {"token": token});

    return Login.fromJson(response.data);
  }

  Future<Capabilities> checkNoteCapability(
      String serverUrl, String token) async {
    final response = await _dio.get("$serverUrl/ocs/v2.php/cloud/capabilities",
        options: Options(headers: {
          'OCS-APIRequest': 'true',
          'Accept': 'application/json',
          'Authorization': 'Basic $token'
        }));

    return Capabilities.fromJson(response.data);
  }
}
