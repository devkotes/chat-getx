import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;

import 'package:get/get.dart';

import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});
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
            child: const Row(
              children: [
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 8,
                ),
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: AssetImage('assets/logo/noimage.png'),
                )
              ],
            ),
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kyunzi Permana',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            Text(
              'online',
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: Get.width,
              child: ListView(
                children: const [
                  ItemChat(
                    isSender: true,
                    message:
                        'Assalamualaikum Wr. wb. \nSelamat Siang Bapak Permana',
                  ),
                  ItemChat(
                    isSender: false,
                    message:
                        'Waalaikum Salaam Wr. Wb \nSelamat Siang Bapak Dadang',
                  ),
                ],
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
                    controller: controller.inputC,
                    focusNode: controller.focusNode,
                    cursorColor: Colors.blue[300],
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
                      controller.inputC.clear();
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
  const ItemChat({super.key, required this.isSender, required this.message});

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
            '18:22 PM',
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
