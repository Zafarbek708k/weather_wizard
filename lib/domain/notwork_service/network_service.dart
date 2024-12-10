import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/cupertino.dart';
import 'package:l/l.dart';
import 'package:weather_wizard/domain/interceptors/connectivity_interceptor.dart';
import 'package:weather_wizard/domain/notwork_service/api_connection.dart';
import 'package:weather_wizard/domain/notwork_service/api_const.dart';
import 'package:weather_wizard/domain/storage/app_storage.dart';

@immutable
class NetworkService {
  const NetworkService._();

  static Future<Dio> initDio() async {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConst.baseUrl,
        // headers: await NetworkService.getHeaders(),
        connectTimeout: ApiConst.connectionTimeout,
        receiveTimeout: ApiConst.sendTimeout,
        sendTimeout: ApiConst.sendTimeout,
        validateStatus: (status) => status != null && status < 205,
      ),
    );

    // dio.interceptors.addAll([
    //   ConnectivityInterceptor(
    //     requestReceiver: Connection(
    //       dio: dio,
    //       connectivity: Connectivity(),
    //     ),
    //   ),
    //   LogInterceptor(
    //     requestBody: true,
    //     responseBody: true,
    //   ),
    // ]);

    // final adapter = dio.httpClientAdapter as IOHttpClientAdapter;
    // adapter.createHttpClient = () {
    //   final client = HttpClient();
    //   client.badCertificateCallback = (cert, host, port) => true; // Disable SSL validation for development
    //   return client;
    // };

    return dio;
  }

  // static Future<Map<String, String>> getHeaders({bool isUpload = false}) async {
  //   final headers = <String, String>{
  //     "Content-type": isUpload ? "multipart/form-data" : "application/json; charset=UTF-8",
  //     "Accept": isUpload ? "multipart/form-data" : "application/json; charset=UTF-8",
  //   };
  //
  //   final token = await AppStorage.$read(key: StorageKey.accessToken) ?? "";
  //
  //   if (token.isNotEmpty) {
  //     headers.putIfAbsent("Authorization", () => "Bearer $token");
  //   }
  //
  //   return headers;
  // }


  static Future<String?> get(String api, Map<String, String> params) async {
    final fullUrl = "${ApiConst.baseUrl}$api";
    log("Request URL: $fullUrl  \n Request Params: $params");
    try {
      final response = await (await initDio()).get<dynamic>(api, queryParameters: params);
      log("response status code = ${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        log("response data == ${response.data}");
        return jsonEncode(response.data);
      }
    } on DioException catch (e) {
      log("DioException: Error at ${e.requestOptions.uri}. Because of ${e.type.name}");
    } catch (e) {
      log("Unexpected error: $e");
    }
    return null;
  }



  static Future<dynamic> getData(String api, Map<String, dynamic> params) async {
    try {
      final fullUrl = "${ApiConst.baseUrl}$api"; log("Request URL: $fullUrl"); log("Request Params: $params");

      final response = await (await initDio()).get<dynamic>(api, queryParameters: params);
      //
      // if (response.data is Map<String, dynamic> || response.data is List) {
      //   log("1");
      //   return response.data; // Return the raw Map or List data
      // }
      // if (response.data is String) {
      //   log("2");
      //   return response.data;
      // }
      // log("3");

      return jsonEncode(response.data);
      // return response.data.toString();
    } on TimeoutException catch (_) {
      log("The connection has timed out, Please try again!");
      rethrow;
    } on DioException catch (e) {
      log("Error: ${e.response.toString()}");
      rethrow;
    } catch (e) {
      log("Error: ${e.toString()}");
      rethrow;
    }
  }



  static Future<String?> post(String api, Map<String, dynamic> data, [Map<String, dynamic> params = const <String, dynamic>{}]) async {
    try {
      final response = await (await initDio()).post<dynamic>(api, data: data, queryParameters: params);
      return jsonEncode(response.data);
    } on TimeoutException catch (_) {
      l.e("The connection has timed out, Please try again!");
      rethrow;
    } on DioException catch (e) {
      l.e(e.response.toString());
      rethrow;
    } on Object catch (_) {
      rethrow;
    }
  }

  static Future<String?> put(String api, Map<String, dynamic> data) async {
    try {
      final response = await (await initDio()).put<dynamic>(api, data: data);

      return jsonEncode(response.data);
    } on TimeoutException catch (_) {
      l.e("The connection has timed out, Please try again!");
      rethrow;
    } on DioException catch (e) {
      l.e(e.response.toString());
      rethrow;
    } on Object catch (_) {
      rethrow;
    }
  }

  static Future<String?> delete(String api, Map<String, dynamic> params) async {
    try {
      final _ = await (await initDio()).delete<dynamic>(api, queryParameters: params);
      return "success";
    } on TimeoutException catch (_) {
      l.e("The connection has timed out, Please try again!");
      rethrow;
    } on DioException catch (e) {
      l.e(e.response.toString());
      rethrow;
    } on Object catch (_) {
      rethrow;
    }
  }
}
