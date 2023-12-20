import 'package:avatar_glow/avatar_glow.dart';
import 'package:chattie/app/controllers/auth_controller.dart';
import 'package:chattie/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({super.key});

  final authC = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => authC.logout(),
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Obx(
            () => Column(
              children: [
                AvatarGlow(
                  glowRadiusFactor: 0.1,
                  glowColor: Colors.grey,
                  duration: const Duration(seconds: 3),
                  child: Container(
                    // margin: const EdgeInsets.only(bottom: 25),
                    width: 175,
                    height: 175,
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
                const SizedBox(
                  height: 20,
                ),
                Text(
                  '${authC.user.value.name}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${authC.user.value.email}',
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Column(
              children: [
                ListTile(
                  onTap: () => Get.toNamed(Routes.UPDATE_STATUS),
                  leading: const Icon(Icons.note_add_outlined),
                  title: const Text(
                    'Update Status',
                    style: TextStyle(fontSize: 18),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_outlined,
                  ),
                ),
                ListTile(
                  onTap: () => Get.toNamed(Routes.CHANGE_PROFILE),
                  leading: const Icon(Icons.person_2_outlined),
                  title: const Text(
                    'Change Profile',
                    style: TextStyle(fontSize: 18),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_outlined,
                  ),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.person_2_outlined),
                  title: const Text(
                    'Change Theme',
                    style: TextStyle(fontSize: 18),
                  ),
                  trailing: const Text('Light'),
                ),
              ],
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(bottom: context.mediaQueryPadding.bottom + 10),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Chattie Apps',
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
                Text(
                  'V.1.0.0',
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
