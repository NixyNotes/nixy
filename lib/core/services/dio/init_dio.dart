// ignore_for_file: inference_failure_on_function_invocation

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:nextcloudnotes/core/services/dio/interceptors/auth.interceptor.dart';
import 'package:nextcloudnotes/core/services/dio/interceptors/base_url.interceptor.dart';

/// The DioService class is a singleton class that provides methods for making HTTP requests using the
/// Dio package in Dart.
@lazySingleton
class DioService {
  /// The DioService class is a singleton class that provides methods for making HTTP requests using the
  /// Dio package in Dart.
  DioService(
    this._authInterceptor,
    this._baseUrlInterceptor,
  ) {
    _dio = Dio(_baseOptions);
    _dio.interceptors.addAll([
      _authInterceptor,
      _baseUrlInterceptor,
    ]);
  }
  final AuthInterceptor _authInterceptor;
  final BaseUrlInterceptor _baseUrlInterceptor;

  late Dio _dio;

  BaseOptions get _baseOptions => BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        contentType: 'application/json',
        validateStatus: (status) {
          return status! >= 200 && status < 300 || status == 304;
        },
      );

  /// This function sends a GET request to a specified path and returns the response if the status code is
  /// OK, otherwise it throws an exception.
  ///
  /// Args:
  ///   path (String): The `path` parameter is a string representing the endpoint or URL path to be
  /// requested using the HTTP GET method.
  ///
  /// Returns:
  ///   A `Future` object that resolves to a `Response<dynamic>` object.
  Future<Response<dynamic>> get<T>(
    String path, [
    Map<String, dynamic>? headers,
  ]) async {
    final request = await _dio.get<T>(path, options: Options(headers: headers));

    if (request.statusCode == HttpStatus.ok ||
        request.statusCode == HttpStatus.notModified) {
      return request;
    }

    throw Exception('Could not fetch: $path');
  }

  /// This function sends a POST request with optional payload and returns the response or throws an
  /// exception if the request fails.
  ///
  /// Args:
  ///   path (String): The endpoint URL to which the POST request will be sent.
  ///   payload (Map<String, dynamic>): The `payload` parameter is an optional `Map` of key-value pairs
  /// that represents the data to be sent in the request body. It is used in the `post` method to send
  /// data to the server. If no payload is provided, the request will still be sent, but the request body
  ///
  /// Returns:
  ///   The method is returning a `Future` object that resolves to a `Response<dynamic>` object.
  Future<Response<dynamic>> post(
    String path, [
    Map<String, dynamic>? payload,
  ]) async {
    final request = await _dio.post(path, data: payload);

    if (request.statusCode == HttpStatus.ok ||
        request.statusCode == HttpStatus.created) {
      return request;
    }

    throw Exception('Could not fetch: $path');
  }

  /// This function sends a DELETE request to a specified path using Dio and returns the response.
  ///
  /// Args:
  ///   path (String): The path parameter is a string that represents the endpoint or resource that the
  /// DELETE request should be sent to. It is typically a URL or URI that identifies the location of the
  /// resource on the server.
  ///
  /// Returns:
  ///   The method is returning a `Future` object that may contain a `Response` object with a dynamic type
  /// or `null`.
  Future<Response<dynamic>?> delete(String path) async {
    try {
      final request = await _dio.delete(path);

      return request;
    } catch (e) {
      throw Exception('Could not send DELETE request: $path');
    }
  }

  /// This function sends a PUT request with a payload to a specified path and returns the response.
  ///
  /// Args:
  ///   path (String): The endpoint URL or path where the PUT request will be sent to.
  ///   payload (Map<String, dynamic>): The `payload` parameter is a `Map` object that contains the data
  /// to be sent in the body of the PUT request. It can contain any key-value pairs that represent the
  /// data to be updated on the server.
  ///
  /// Returns:
  ///   The method is returning a `Future` object that resolves to a `Response<dynamic>` object or `null`
  /// if the response is not available.
  Future<Response<dynamic>?> put(
    String path,
    Map<String, dynamic> payload,
  ) async {
    try {
      final request = await _dio.put(path, data: payload);

      return request;
    } catch (e) {
      throw Exception('Could not send PUT request: $path: $e');
    }
  }

  /// The function `patch` sends a PATCH request to a specified path with a payload and returns the
  /// response.
  ///
  /// Args:
  ///   path (String): The path parameter is a string that represents the endpoint or URL where the PATCH
  /// request will be sent to. It specifies the location of the resource that needs to be updated or
  /// modified.
  ///   payload (Map<String, dynamic>): A map containing the data to be sent in the PATCH request body.
  /// The keys in the map represent the field names, and the values represent the corresponding field
  /// values. The values can be of any type, as long as they are JSON-serializable.
  ///
  /// Returns:
  ///   a `Future<Response<dynamic>?>`.
  Future<Response<dynamic>?> patch(
    String path,
    Map<String, dynamic> payload,
  ) async {
    try {
      final request = await _dio.patch(path, data: payload);

      return request;
    } catch (e) {
      throw Exception('Could not send PATCH request: $path: $e');
    }
  }
}
