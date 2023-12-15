import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  late TextEditingController inputC;
  var isShowEmoji = false.obs;

  late FocusNode focusNode;

  @override
  void onInit() {
    inputC = TextEditingController();

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
    super.onClose();
  }
}
