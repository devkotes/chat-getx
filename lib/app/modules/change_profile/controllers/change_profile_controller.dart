import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChangeProfileController extends GetxController {
  late TextEditingController emailC;
  late TextEditingController nameC;
  late TextEditingController statusC;
  late ImagePicker imagePicker;

  XFile? pickerImage;

  FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> selectedImage() async {
    try {
      final select = await imagePicker.pickImage(source: ImageSource.gallery);
      if (select != null) {
        debugPrint('Select Image name: ${select.name}');
        debugPrint('Select Image path: ${select.path}');
        pickerImage = select;
      }
      update();
    } catch (e, s) {
      debugPrint('selectedImage Error : $e');
      debugPrint('selectedImage Error stack: $s');
    }
  }

  Future<void> resetImage() async {
    pickerImage = null;
    update();
  }

  Future<String?> uploadPhoto({required String uid}) async {
    try {
      Reference storageRef = storage.ref('$uid.png');

      File file = File(pickerImage!.path);

      await storageRef.putFile(file);

      String downloadUrl = await storageRef.getDownloadURL();

      return downloadUrl;
    } catch (e, s) {
      debugPrint('uploadPhoto Error : $e');
      debugPrint('uploadPhoto Error stack: $s');
      return null;
    }
  }

  @override
  void onInit() {
    emailC = TextEditingController();
    nameC = TextEditingController();
    statusC = TextEditingController();
    imagePicker = ImagePicker();
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
