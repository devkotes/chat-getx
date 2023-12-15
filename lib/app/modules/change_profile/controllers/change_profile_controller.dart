import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeProfileController extends GetxController {
  late TextEditingController emailC;
  late TextEditingController nameC;
  late TextEditingController statusC;

  @override
  void onInit() {
    emailC = TextEditingController(text: 'dadangcasper@gmail.com');
    nameC = TextEditingController(text: 'Dadang Casper');
    statusC = TextEditingController(text: 'Let\'s Start');
    super.onInit();
  }

  @override
  void onClose() {
    emailC.dispose();
    nameC.dispose();
    statusC.dispose();
    super.onClose();
  }
}
