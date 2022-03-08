import 'dart:convert';

import 'package:folarium_test_apps/api/api_base.dart';
import 'package:folarium_test_apps/global/string_global.dart';
import 'package:folarium_test_apps/models/response_biodata.dart';
import 'package:folarium_test_apps/models/response_insert.dart';

class ApiClient {
  static Future<ResponseInsert?> insertBiodata(
      {Map<String, dynamic>? formData}) async {
    ResponseInsert? responseInsert;
    await ApiBase.postData(StringGlobal.INSERT_BIODATA, data: formData)
        .then((response) {
      if (response != null) {
        responseInsert = ResponseInsert.fromJson(jsonDecode(response.data));
      }
    });

    return responseInsert;
  }

  static Future<ResponseBiodata?> biodata(
      {Map<String, dynamic>? parameters}) async {
    ResponseBiodata? responseBiodata;
    await ApiBase.getData(StringGlobal.BIODATA, parameters: parameters)
        .then((response) {
      if (response != null) {
        responseBiodata = ResponseBiodata.fromJson(jsonDecode(response.data));
      }
    });

    return responseBiodata;
  }

  static Future<void> sendPushMessage({Map<String, dynamic>? data}) async {
    try {
      await ApiBase.postData(
        'https://fcm.googleapis.com/fcm/send',
        useCustomBaseUrl: true,
        data: data,
        useEncodeBody: true,
        authKey:
            'key=AAAAtHg1ptM:APA91bE3uu_zqzfok9pN28h80MwlvrjwOirYFA4aCE6gNhZD60q7eq5Vf-_gRbaKRh03JYvog9seTzKG_H1iyXgPjvWffOnouG5Mu4dMx3l5u3lOv1ptI85J1XB1c_QBPENUt7Hbfnb4',
      ).then((value) {
        print(value);
      }).catchError((err) {
        print("err");
        print(err.toString());
      });
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }
}
