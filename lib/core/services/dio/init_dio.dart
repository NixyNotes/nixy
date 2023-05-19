import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:nextcloudnotes/core/controllers/auth.controller.dart';
import 'package:nextcloudnotes/core/services/dio/interceptors/auth.interceptor.dart';

@lazySingleton
class DioService {
  final AuthController _authController;
  final AuthInterceptor _authInterceptor;

  late Dio _dio;

  String? get baseUrl => _authController.currentAccount.value?.server;

  BaseOptions get _baseOptions => BaseOptions(
        baseUrl: baseUrl ?? "NONNE",
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
        contentType: "application/json",
        responseType: ResponseType.json,
      );

  DioService(this._authController, this._authInterceptor) {
    _dio = Dio(_baseOptions);
    _dio.interceptors.add(_authInterceptor);
  }

  Future<Response<dynamic>?> get(String path) async {
    final request = await _dio.get(path);

    if (request.statusCode == HttpStatus.ok) {
      return request;
    }

    throw Exception("Could not fetch: $path");
  }

  Future<Response<dynamic>?> post(
      String path, Map<String, dynamic> payload) async {
    final request = await _dio.post(path, data: payload);

    if (request.statusCode == HttpStatus.ok ||
        request.statusCode == HttpStatus.created) {
      return request;
    }

    throw Exception("Could not fetch: $path");
  }

  Future<Response<dynamic>?> delete(String path) async {
    try {
      final request = await _dio.delete(path);

      if (request.statusCode == HttpStatus.noContent) {
        return request;
      }
    } catch (e) {
      throw Exception("Could not send DELETE request: $path");
    }
    return null;
  }
}
