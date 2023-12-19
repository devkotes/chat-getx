import 'package:chattie/app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/search_person_controller.dart';

class SearchPersonView extends GetView<SearchPersonController> {
  SearchPersonView({super.key});

  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: AppBar(
            backgroundColor: Colors.blue[300],
            title: const Text(
              'SearchPersonView',
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
            flexibleSpace: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 50,
                  child: TextField(
                    controller: controller.searchC,
                    onChanged: (value) => controller.searchFriend(
                        search: value, email: authC.user.value.email!),
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Search new friend here ...',
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      suffixIcon: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          debugPrint('SEARCH');
                        },
                        child: const Icon(
                          Icons.search_rounded,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Obx(
          () => (controller.tempSearch.isEmpty)
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Get.width * 0.6,
                        height: Get.width * 0.6,
                        child: Lottie.asset('assets/lottie/empty.json'),
                      ),
                      const Text(
                        'Data tidak ditemukan',
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 10),
                  itemCount: controller.tempSearch.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: (controller.tempSearch[index]['photoUrl'] !=
                                  null)
                              ? NetworkImage(
                                      controller.tempSearch[index]['photoUrl'])
                                  as ImageProvider
                              : const AssetImage('assets/logo/noimage.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      '${controller.tempSearch[index]["name"]}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      '${controller.tempSearch[index]["email"]}',
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    trailing: InkWell(
                      onTap: () => authC.addConnection(
                          friendEmail: controller.tempSearch[index]["email"]),
                      child: Chip(
                        side: BorderSide(color: Colors.blue[400]!),
                        backgroundColor: Colors.blue[400],
                        label: const Text(
                          'Message',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
        ));
  }
}
