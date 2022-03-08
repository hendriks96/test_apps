import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:folarium_test_apps/global/string_global.dart';

class ApiBase {
  static Future<Response?> postData(
    String endpoint, {
    Map<String, dynamic>? data,
    bool useCustomBaseUrl = false,
    String authKey = '',
    bool useEncodeBody = false,
  }) async {
    Dio dio = new Dio();
    Response? response;
    FormData formData = FormData.fromMap(data!);

    print(StringGlobal.BASE_URL + endpoint);

    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = authKey;

    await dio
        .post(
      useCustomBaseUrl ? endpoint : StringGlobal.BASE_URL + endpoint,
      data: useEncodeBody ? jsonEncode(data) : formData,
    )
        .then((resp) {
      print(resp);
      if (resp.statusCode == 200) {
        response = resp;
      }
    }).catchError((err) {
      print(err.toString());
    });

    return response;
  }

  static Future<Response?> getData(String endpoint,
      {Map<String, dynamic>? parameters}) async {
    Response? response;

    print(StringGlobal.BASE_URL + endpoint + '?id=${parameters!['id']}');

    await Dio()
        .get(
      StringGlobal.BASE_URL + endpoint,
      queryParameters: parameters,
    )
        .then((resp) {
      print(resp);
      if (resp.statusCode == 200) {
        response = resp;
      }
    }).catchError((err) {
      print(err.toString());
    });

    return response;
  }
}
