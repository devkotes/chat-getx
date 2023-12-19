// To parse this JSON data, do
//
//     final chatsModel = chatsModelFromJson(jsonString);

import 'dart:convert';

ChatsModel chatsModelFromJson(String str) =>
    ChatsModel.fromJson(json.decode(str));

String chatsModelToJson(ChatsModel data) => json.encode(data.toJson());

class ChatsModel {
  List<String>? connections;
  List<Chat>? chat;

  ChatsModel({
    this.connections,
    this.chat,
  });

  factory ChatsModel.fromJson(Map<String, dynamic> json) => ChatsModel(
        connections: json["connections"] == null
            ? []
            : List<String>.from(json["connections"]!.map((x) => x)),
        chat: json["chat"] == null
            ? []
            : List<Chat>.from(json["chat"]!.map((x) => Chat.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "connections": connections == null
            ? []
            : List<dynamic>.from(connections!.map((x) => x)),
        "chat": chat == null
            ? []
            : List<dynamic>.from(chat!.map((x) => x.toJson())),
      };
}

class Chat {
  String? pengirim;
  String? penerima;
  String? pesan;
  DateTime? time;
  bool? isRead;

  Chat({
    this.pengirim,
    this.penerima,
    this.pesan,
    this.time,
    this.isRead,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        pengirim: json["pengirim"],
        penerima: json["penerima"],
        pesan: json["pesan"],
        time: json["time"] == null ? null : DateTime.parse(json["time"]),
        isRead: json["isRead"],
      );

  Map<String, dynamic> toJson() => {
        "pengirim": pengirim,
        "penerima": penerima,
        "pesan": pesan,
        "time": time?.toIso8601String(),
        "isRead": isRead,
      };
}
