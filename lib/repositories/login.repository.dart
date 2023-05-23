import 'package:injectable/injectable.dart';
import 'package:nextcloudnotes/core/services/dio/init_dio.dart';
import 'package:nextcloudnotes/models/login.model.dart';
import 'package:nextcloudnotes/models/login_poll.model.dart';

@lazySingleton
class LoginRepository {
  LoginRepository(this._dio);
  final DioService _dio;

  Future<LoginPoll> fetchLoginPoll(String serverUrl) async {
    final response = await _dio.post("$serverUrl/index.php/login/v2");

    return LoginPoll.fromJson(response.data);
  }

  Future<Login> fetchAppPassword(String serverUrl, String token) async {
    final response =
        await _dio.post("$serverUrl/index.php/login/v2/poll", {"token": token});

    return Login.fromJson(response.data);
  }
}
