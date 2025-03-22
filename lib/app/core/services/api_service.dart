import 'dart:convert';
import 'dart:io';

import 'package:broker/app/config/utils/app_utils/api_constans.dart';
import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import '../../config/utils/exceptions/exceptions.dart';
import '../model/response_model.dart';

class ApiService {


  // dio instance
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConstans.baseUrl,
    receiveDataWhenStatusError: true,
    connectTimeout: const Duration(milliseconds: 60 * 1000),
    sendTimeout: const Duration(milliseconds: 60 * 1000),
    receiveTimeout: const Duration(milliseconds: 60 * 1000),
  ))
    ..interceptors.add(LogInterceptor(
        request: false,
        responseHeader: false,
        error: true,
        requestBody: true,
        responseBody: true
    ));

  /// Helper function to set headers
  static void setHeaders({bool isFormData = false}) {
    _dio.options.headers = {
      'Content-Type': isFormData ? 'multipart/form-data' : 'application/json',
      'Accept': 'application/json',
      'LanguageCode':Get.locale?.languageCode??"ar"
    };
  }

  /// GET request
  static Future<ResponseModel> get({
    required String endPoint,
    Map<String, dynamic>? query,
    Map<String, dynamic> data = const {},
    bool showErrorMessage = true,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      setHeaders(isFormData: false);
      final response = await _dio.get(
        endPoint,
        queryParameters: query,
        onReceiveProgress: onReceiveProgress,
      );
      return ResponseModel.fromJson(response.data);
    } on DioException catch (error) {
      throw handleDioExceptions(error);
    } on SocketException {
      throw AppException('No Internet connection');
    } on FormatException catch (e) {
      throw AppException("Invalid format: ${e.message}");
    } catch (e) {
      throw AppException("Unexpected error: ${e.toString()}");
    }
  }

  /// POST request
  static Future<ResponseModel> post({
    required String endPoint,
    bool showErrorMessage = true,
    dynamic data = const {},
    bool isFormData = false,
    dynamic query,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      setHeaders(isFormData: isFormData);

      final response = await _dio.post(
        endPoint,
        data: isFormData ? FormData.fromMap(data) : jsonEncode(data),
        queryParameters: query,
        onSendProgress: onSendProgress,
      );
      
      return ResponseModel.fromJson(response.data);
    } on DioException catch (error) {
      throw handleDioExceptions(error);
    } on SocketException {
      throw AppException('No Internet connection');
    } on FormatException catch (e) {
      throw AppException("Invalid format: ${e.message}");
    } catch (e) {
      throw AppException("Unexpected error: ${e.toString()}");
    }
  }

  static Future<ResponseModel> delete({
    required String endPoint,
    bool showErrorMessage = true,
    Map<String, dynamic> data = const {},
    bool isFormData = false,
    Map<String, dynamic>? query,
  }) async {
    try {
      setHeaders(isFormData: isFormData);

      final response = await _dio.delete(endPoint,
          data: isFormData ? FormData.fromMap(data) : jsonEncode(data),
          queryParameters: query);

      return ResponseModel.fromJson(response.data);
    } on DioException catch (error) {
      throw handleDioExceptions(error);
    } on SocketException {
      throw AppException('No Internet connection');
    } on FormatException catch (e) {
      throw AppException("Invalid format: ${e.message}");
    } catch (e) {
      throw AppException("Unexpected error: ${e.toString()}");
    }
  }
}
