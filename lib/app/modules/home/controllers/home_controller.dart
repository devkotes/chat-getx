import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> chatStream({
    required String email,
  }) {
    return firestore
        .collection('users')
        .doc(email)
        .collection('chats')
        .orderBy('lastTime', descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> friendStream({
    required String email,
  }) {
    return firestore.collection('users').doc(email).snapshots();
  }

  Future<void> goToChat({
    String? chatId,
    required String email,
    required String friendEmail,
  }) async {
    try {
      CollectionReference userCollection = firestore.collection('users');
      CollectionReference chatCollection = firestore.collection('chats');

      final updateStatusChat = await chatCollection
          .doc(chatId)
          .collection('chat')
          .where('isRead', isEqualTo: false)
          .where('penerima', isEqualTo: email)
          .get();

      for (var element in updateStatusChat.docs) {
        await chatCollection
            .doc(chatId)
            .collection('chat')
            .doc(element.id)
            .update({"isRead": true});
      }

      await userCollection
          .doc(email)
          .collection('chats')
          .doc(chatId)
          .update({"totalUnread": 0});

      Get.toNamed(Routes.CHAT, arguments: {
        "chatId": chatId,
        "friendEmail": friendEmail,
      });
    } catch (e, stack) {
      debugPrint('goToChat Error : $e');
      debugPrint('goToChat Error stack: $stack');
    }
  }
}
