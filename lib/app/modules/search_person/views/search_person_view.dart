import 'package:chattie/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/search_person_controller.dart';

class SearchPersonView extends GetView<SearchPersonController> {
  SearchPersonView({super.key});

  final List<Widget> frientList = List.generate(
    20,
    (index) => ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.black26,
        child: Image.asset('assets/logo/noimage.png'),
      ),
      title: Text(
        'Nama ke ${index + 1}',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        'nama${index + 1}@gmail.com',
        style: const TextStyle(
          fontSize: 13,
        ),
      ),
      trailing: InkWell(
        onTap: () => Get.toNamed(Routes.CHAT),
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
  );

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
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Search new friend here ...',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
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
      body: (frientList.isEmpty)
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
              itemCount: frientList.length,
              itemBuilder: (context, index) => frientList[index],
            ),
    );
  }
}
