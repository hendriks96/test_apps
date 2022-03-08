// To parse this JSON data, do
//
//     final responseBiodata = responseBiodataFromJson(jsonString);

import 'dart:convert';

ResponseBiodata responseBiodataFromJson(String str) =>
    ResponseBiodata.fromJson(json.decode(str));

String responseBiodataToJson(ResponseBiodata data) =>
    json.encode(data.toJson());

class ResponseBiodata {
  ResponseBiodata({
    this.status,
    this.success,
    this.message,
    this.data,
  });

  int? status;
  bool? success;
  String? message;
  Data? data;

  factory ResponseBiodata.fromJson(Map<String, dynamic> json) =>
      ResponseBiodata(
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
    this.fullName,
    this.gender,
    this.dateOfBirth,
    this.currentLocation,
    this.imageUrl,
    this.tokenId,
  });

  int? userId;
  String? fullName;
  String? gender;
  DateTime? dateOfBirth;
  String? currentLocation;
  String? imageUrl;
  String? tokenId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"] == null ? null : json["user_id"],
        fullName: json["full_name"] == null ? null : json["full_name"],
        gender: json["gender"] == null ? null : json["gender"],
        dateOfBirth: json["date_of_birth"] == null
            ? null
            : DateTime.parse(json["date_of_birth"]),
        currentLocation:
            json["current_location"] == null ? null : json["current_location"],
        imageUrl: json["image_url"] == null ? null : json["image_url"],
        tokenId: json["token_id"] == null ? null : json["token_id"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId == null ? null : userId,
        "full_name": fullName == null ? null : fullName,
        "gender": gender == null ? null : gender,
        "date_of_birth": dateOfBirth == null
            ? null
            : "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
        "current_location": currentLocation == null ? null : currentLocation,
        "image_url": imageUrl == null ? null : imageUrl,
        "token_id": tokenId == null ? null : tokenId,
      };
}
