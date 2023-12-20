import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatController extends GetxController {
  late ScrollController scrollC;
  late TextEditingController inputC;
  var isShowEmoji = false.obs;

  late FocusNode focusNode;

  FirebaseFirestore firebase = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> streamChat({
    required String chatId,
  }) {
    CollectionReference chats = firebase.collection('chats');
    return chats.doc(chatId).collection('chat').orderBy('time').snapshots();
  }

  Stream<DocumentSnapshot<Object?>> streamFriendData(
      {required String friendEmail}) {
    CollectionReference users = firebase.collection('users');
    return users.doc(friendEmail).snapshots();
  }

  Future<void> sendChat({
    required String email,
    required Map<String, dynamic> argument,
    String? chat,
  }) async {
    try {
      CollectionReference chats = firebase.collection('chats');
      CollectionReference users = firebase.collection('users');
      var date = DateTime.now().toIso8601String();

      chats.doc(argument['chatId']).collection('chat').add({
        "pengirim": email,
        "penerima": argument['friendEmail'],
        "pesan": chat,
        "time": date,
        "isRead": false,
        "groupTime": DateFormat.yMMMMd('en_US').format(DateTime.parse(date)),
      });

      Timer(const Duration(milliseconds: 100), () {
        debugPrint('CHAT CONTROLLER');
        scrollC.animateTo(scrollC.position.maxScrollExtent,
            duration: const Duration(milliseconds: 100), curve: Curves.ease);
      });

      inputC.clear();

      users.doc(email).collection('chats').doc(argument['chatId']).update({
        "lastTime": date,
      });

      final checkChatFriend = await users
          .doc(argument['friendEmail'])
          .collection('chats')
          .doc(argument['chatId'])
          .get();

      if (checkChatFriend.exists) {
        //exists

        final checkTotalUnread = await chats
            .doc(argument['chatId'])
            .collection('chat')
            .where('isRead', isEqualTo: false)
            .where('pengirim', isEqualTo: email)
            .get();

        int totalUnread = checkTotalUnread.docs.length;

        await users
            .doc(argument['friendEmail'])
            .collection('chats')
            .doc(argument['chatId'])
            .update({"lastTime": date, "totalUnread": totalUnread});
      } else {
        // not exists
        await users
            .doc(argument['friendEmail'])
            .collection('chats')
            .doc(argument['chatId'])
            .set({
          "connection": email,
          "lastTime": date,
          "totalUnread": 1,
        });
      }
    } catch (e, s) {
      debugPrint('sendChat Error : $e');
      debugPrint('sendChat Error stack: $s');
    }
  }

  @override
  void onInit() {
    inputC = TextEditingController();
    scrollC = ScrollController();

    focusNode = FocusNode();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        isShowEmoji.value = false;
      }
    });

    super.onInit();
  }

  @override
  void onClose() {
    inputC.dispose();
    focusNode.dispose();
    scrollC.dispose();
    super.onClose();
  }
}
