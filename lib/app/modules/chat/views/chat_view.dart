import 'dart:async';

import 'package:chattie/app/controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  ChatView({super.key});

  final authC = Get.find<AuthController>();
  final chatId = (Get.arguments as Map<String, dynamic>)['chatId'];
  final friendEmail = (Get.arguments as Map<String, dynamic>)['friendEmail'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        leadingWidth: 90,
        leading: InkWell(
          onTap: () => Get.back(),
          child: Container(
            margin: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 8,
                ),
                StreamBuilder<DocumentSnapshot<Object?>>(
                  stream: controller.streamFriendData(friendEmail: friendEmail),
                  builder: (context, snapshotFriend) {
                    if (snapshotFriend.connectionState ==
                        ConnectionState.active) {
                      var dataFriend =
                          snapshotFriend.data!.data() as Map<String, dynamic>;
                      if (dataFriend['photoUrl'] != null) {
                        return CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(dataFriend['photoUrl']),
                        );
                      } else {
                        return const CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage:
                              AssetImage('assets/logo/noimage.png'),
                        );
                      }
                    }
                    return const CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: AssetImage('assets/logo/noimage.png'),
                    );
                  },
                )
              ],
            ),
          ),
        ),
        title: StreamBuilder<DocumentSnapshot<Object?>>(
            stream: controller.streamFriendData(friendEmail: friendEmail),
            builder: (context, snapshotFriend) {
              if (snapshotFriend.connectionState == ConnectionState.active) {
                var dataFriend =
                    snapshotFriend.data!.data() as Map<String, dynamic>;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dataFriend['name'],
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      dataFriend['status'],
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ],
                );
              }
              return const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'loading ...',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Text(
                    'loading ...',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              );
            }),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: Get.width,
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: controller.streamChat(chatId: chatId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    var listChats = snapshot.data?.docs;
                    // Jump to Last Chat
                    Timer(const Duration(milliseconds: 100), () {
                      debugPrint('CHAT VIEW');
                      controller.scrollC.animateTo(
                          controller.scrollC.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.ease);
                    });

                    return ListView.builder(
                      controller: controller.scrollC,
                      itemCount: listChats?.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            (index == 0 ||
                                    listChats?[index]['groupTime'] !=
                                        listChats?[index - 1]['groupTime'])
                                ? Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.grey.withOpacity(0.05),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Text(
                                          listChats?[index]['groupTime'],
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.blue[300]),
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                            ItemChat(
                              isSender: (listChats?[index]['pengirim'] ==
                                  authC.user.value.email),
                              message: listChats?[index]['pesan'],
                              time: listChats?[index]['time'],
                            ),
                          ],
                        );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                bottom: (controller.isShowEmoji.value)
                    ? 5
                    : context.mediaQueryPadding.bottom),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            width: Get.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    autocorrect: false,
                    controller: controller.inputC,
                    focusNode: controller.focusNode,
                    textInputAction: TextInputAction.done,
                    cursorColor: Colors.blue[300],
                    onEditingComplete: () {
                      controller.sendChat(
                        email: authC.user.value.email!,
                        argument: Get.arguments as Map<String, dynamic>,
                        chat: controller.inputC.text,
                      );
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      prefixIcon: IconButton(
                        onPressed: () {
                          controller.focusNode.unfocus();
                          controller.isShowEmoji.toggle();
                        },
                        icon: const Icon(Icons.emoji_emotions_outlined),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(color: Colors.blue[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(color: Colors.blue[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(color: Colors.blue[300]!),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Material(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.blue[300],
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () {
                      controller.sendChat(
                        email: authC.user.value.email!,
                        argument: Get.arguments as Map<String, dynamic>,
                        chat: controller.inputC.text,
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Icon(
                        Icons.send_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Obx(
            () => (controller.isShowEmoji.value)
                ? SizedBox(
                    height: 325,
                    child: EmojiPicker(
                      // onEmojiSelected: (Category? category, Emoji emoji) {
                      //   // Do something when emoji is tapped (optional)
                      // },
                      onBackspacePressed: () {
                        // Do something when the user taps the backspace button (optional)
                        // Set it to null to hide the Backspace-Button
                      },
                      textEditingController: controller.inputC,
                      config: Config(
                        columns: 7,
                        emojiSizeMax: 32 *
                            (foundation.defaultTargetPlatform ==
                                    TargetPlatform.iOS
                                ? 1.30
                                : 1.0),
                        verticalSpacing: 0,
                        horizontalSpacing: 0,
                        gridPadding: EdgeInsets.zero,
                        initCategory: Category.RECENT,
                        bgColor: const Color(0xFFF2F2F2),
                        indicatorColor: Colors.blue[300]!,
                        iconColor: Colors.grey,
                        iconColorSelected: Colors.blue[300]!,
                        backspaceColor: Colors.blue[300]!,
                        skinToneDialogBgColor: Colors.white,
                        skinToneIndicatorColor: Colors.grey,
                        enableSkinTones: true,
                        recentTabBehavior: RecentTabBehavior.RECENT,
                        recentsLimit: 28,
                        noRecents: const Text(
                          'No Recents',
                          style: TextStyle(fontSize: 20, color: Colors.black26),
                          textAlign: TextAlign.center,
                        ), // Needs to be const Widget
                        loadingIndicator:
                            const SizedBox.shrink(), // Needs to be const Widget
                        tabIndicatorAnimDuration: kTabScrollDuration,
                        categoryIcons: const CategoryIcons(),
                        buttonMode: ButtonMode.MATERIAL,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          )
        ],
      ),
    );
  }
}

class ItemChat extends StatelessWidget {
  final bool isSender;
  final String message;
  final String time;
  const ItemChat(
      {super.key,
      required this.isSender,
      required this.message,
      required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      alignment: (isSender) ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            (isSender) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color:
                  (isSender) ? Colors.blue[300] : Colors.grey.withOpacity(0.1),
              borderRadius: (isSender)
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    )
                  : const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
            ),
            child: Text(
              message,
              style: TextStyle(
                color: (isSender) ? Colors.white : Colors.black45,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            DateFormat.jm().format(DateTime.parse(time)),
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
