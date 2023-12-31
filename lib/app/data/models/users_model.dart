// To parse this JSON data, do
//
//     final usersModel = usersModelFromJson(jsonString);

import 'dart:convert';

UsersModel usersModelFromJson(String str) =>
    UsersModel.fromJson(json.decode(str));

String usersModelToJson(UsersModel data) => json.encode(data.toJson());

class UsersModel {
  String? uid;
  String? name;
  String? keyName;
  String? email;
  String? creationTime;
  String? lastSignInTime;
  String? photoUrl;
  String? status;
  String? updatedTime;
  List<ChatInUser>? chats;

  UsersModel({
    this.uid,
    this.name,
    this.keyName,
    this.email,
    this.creationTime,
    this.lastSignInTime,
    this.photoUrl,
    this.status,
    this.updatedTime,
    this.chats,
  });

  factory UsersModel.fromJson(Map<String, dynamic> json) => UsersModel(
        uid: json["uid"],
        name: json["name"],
        keyName: json["keyName"],
        email: json["email"],
        creationTime: json["creationTime"],
        lastSignInTime: json["lastSignInTime"],
        photoUrl: json["photoUrl"],
        status: json["status"],
        updatedTime: json["updatedTime"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "keyName": keyName,
        "email": email,
        "creationTime": creationTime,
        "lastSignInTime": lastSignInTime,
        "photoUrl": photoUrl,
        "status": status,
        "updatedTime": updatedTime,
      };
}

class ChatInUser {
  String? connection;
  String? chatId;
  String? lastTime;
  int? totalUnread;

  ChatInUser({
    this.connection,
    this.chatId,
    this.lastTime,
    this.totalUnread,
  });

  factory ChatInUser.fromJson(Map<String, dynamic> json) => ChatInUser(
        connection: json["connection"],
        chatId: json["chatId"],
        lastTime: json["lastTime"],
        totalUnread: json["totalUnread"],
      );

  Map<String, dynamic> toJson() => {
        "connection": connection,
        "chatId": chatId,
        "lastTime": lastTime,
        "totalUnread": totalUnread,
      };
}
