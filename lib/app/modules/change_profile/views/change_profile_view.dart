import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../controllers/change_profile_controller.dart';

class ChangeProfileView extends GetView<ChangeProfileController> {
  ChangeProfileView({super.key});
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    controller.emailC.text = authC.user.value.email!;
    controller.nameC.text = authC.user.value.name!;
    controller.statusC.text = authC.user.value.status!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        title: const Text(
          'Change Profile',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => authC.changeProfile(
              name: controller.nameC.text,
              status: controller.statusC.text,
            ),
            icon: const Icon(
              Icons.save_alt_sharp,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(
                () => AvatarGlow(
                  glowRadiusFactor: 0.1,
                  glowColor: Colors.grey,
                  duration: const Duration(seconds: 3),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: (authC.user.value.photoUrl != null)
                            ? NetworkImage(authC.user.value.photoUrl!)
                                as ImageProvider
                            : const AssetImage('assets/logo/noimage.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                readOnly: true,
                controller: controller.emailC,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(fontSize: 13),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelText: 'Email',
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.blue[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.blue[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.blue[300]!),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: controller.nameC,
                style: const TextStyle(fontSize: 13),
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.blue[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.blue[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.blue[300]!),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: controller.statusC,
                style: const TextStyle(fontSize: 13),
                cursorColor: Colors.black,
                textInputAction: TextInputAction.done,
                onEditingComplete: () {
                  authC.changeProfile(
                    name: controller.nameC.text,
                    status: controller.statusC.text,
                  );
                },
                decoration: InputDecoration(
                  labelText: 'Status',
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.blue[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.blue[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.blue[300]!),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GetBuilder<ChangeProfileController>(builder: (c) {
                      if (c.pickerImage != null) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    image: DecorationImage(
                                      image:
                                          FileImage(File(c.pickerImage!.path)),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => controller.resetImage(),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.delete_outline_rounded),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextButton(
                                onPressed: () {
                                  controller
                                      .uploadPhoto(uid: authC.user.value.uid!)
                                      .then((photoUrl) {
                                    if (photoUrl != null) {
                                      authC.changePhotoProfile(
                                          photoUrl: photoUrl);
                                    }
                                  });
                                },
                                child: const Text('Upload'))
                          ],
                        );
                      }
                      return const Text('no Image');
                    }),
                    TextButton(
                      onPressed: () {
                        controller.selectedImage();
                      },
                      child: const Text('Choose file'),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: Get.width,
                child: ElevatedButton(
                  onPressed: () => authC.changeProfile(
                    name: controller.nameC.text,
                    status: controller.statusC.text,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[300],
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                  ),
                  child: const Text(
                    'Change Profile',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
