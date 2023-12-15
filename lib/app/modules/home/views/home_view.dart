import 'package:chattie/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});
  final List<Widget> myChat = List.generate(
    20,
    (index) => ListTile(
      onTap: () => Get.toNamed(Routes.CHAT),
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
        'Ini Status orang ke ${index + 1}',
        style: const TextStyle(
          fontSize: 13,
        ),
      ),
      trailing: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue[600],
        ),
        child: const Center(
          child: Text(
            '3',
            style: TextStyle(fontSize: 8, color: Colors.white),
          ),
        ),
      ),
    ),
  ).reversed.toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Material(
            elevation: 4,
            child: Container(
              margin: EdgeInsets.only(top: context.mediaQueryPadding.top),
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'CHATS',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Material(
                    color: Colors.blue[300],
                    borderRadius: BorderRadius.circular(50),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () => Get.toNamed(Routes.PROFILE),
                      child: const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: myChat.length,
              itemBuilder: (context, index) => myChat[index],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50.0),
          ),
        ),
        backgroundColor: Colors.blue[300],
        onPressed: () => Get.toNamed(Routes.SEARCH_PERSON),
        child: const Icon(
          Icons.search_rounded,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}
