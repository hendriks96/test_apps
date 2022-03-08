// To parse this JSON data, do
//
//     final responseInsert = responseInsertFromJson(jsonString);

import 'dart:convert';

ResponseInsert responseInsertFromJson(String str) =>
    ResponseInsert.fromJson(json.decode(str));

String responseInsertToJson(ResponseInsert data) => json.encode(data.toJson());

class ResponseInsert {
  ResponseInsert({
    this.status,
    this.success,
    this.message,
    this.data,
  });

  int? status;
  bool? success;
  String? message;
  Data? data;

  factory ResponseInsert.fromJson(Map<String, dynamic> json) => ResponseInsert(
        status: json["status"] == null ? null : json["status"],
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toJson(),
      };
}

class Data {
  Data({
    this.userId,
    this.tokenId,
  });

  int? userId;
  String? tokenId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"] == null ? null : json["user_id"],
        tokenId: json["token_id"] == null ? null : json["token_id"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId == null ? null : userId,
        "token_id": tokenId == null ? null : tokenId,
      };
}
