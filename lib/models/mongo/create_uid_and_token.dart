// To parse this JSON data, do
//
//     final createUidAndToken = createUidAndTokenFromJson(jsonString);

import 'dart:convert';

CreateUidAndToken createUidAndTokenFromJson(String str) =>
    CreateUidAndToken.fromJson(json.decode(str));

String createUidAndTokenToJson(CreateUidAndToken data) =>
    json.encode(data.toJson());

class CreateUidAndToken {
  CreateUidAndToken({
    required this.uid,
    required this.platform,
    required this.token,
    required this.crDate,
    required this.boolId,
  });

  String uid;
  String platform;
  String token;
  String crDate;
  int boolId;

  factory CreateUidAndToken.fromJson(Map<String, dynamic> json) =>
      CreateUidAndToken(
        uid: json["uid"],
        platform: json["platform"],
        token: json["token"],
        crDate: json["crDate"],
        boolId: json["boolId"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "platform": platform,
        "token": token,
        "crDate": crDate,
        "boolId": boolId,
      };
}
