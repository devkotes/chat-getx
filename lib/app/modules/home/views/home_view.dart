import 'package:chattie/app/controllers/auth_controller.dart';
import 'package:chattie/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});
  final authC = Get.find<AuthController>();

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
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: controller.chatStream(email: authC.user.value.email!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  var allChats = (snapshot.data!.data()
                      as Map<String, dynamic>)['chats'] as List;
                  debugPrint('Data Chat : $allChats');
                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: allChats.length,
                    itemBuilder: (context, index) {
                      return StreamBuilder<
                          DocumentSnapshot<Map<String, dynamic>>>(
                        stream: controller.friendStream(
                            email: allChats[index]['connection']),
                        builder: (context, snapshotFriend) {
                          if (snapshotFriend.connectionState ==
                              ConnectionState.active) {
                            var data = snapshotFriend.data!.data()!;
                            return ListTile(
                              onTap: () => Get.toNamed(Routes.CHAT),
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.black38,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: (data['photoUrl'] != null)
                                        ? NetworkImage(data['photoUrl'])
                                            as ImageProvider
                                        : const AssetImage(
                                            'assets/logo/noimage.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              title: Text(
                                '${data["name"]}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              // subtitle: Text(
                              //   'Ini Status orang ke ${index + 1}',
                              //   style: const TextStyle(
                              //     fontSize: 13,
                              //   ),
                              // ),
                              trailing: (allChats[index]['total_unread'] == 0)
                                  ? const SizedBox.shrink()
                                  : Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blue[600],
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${allChats[index]['total_unread']}',
                                          style: const TextStyle(
                                              fontSize: 8, color: Colors.white),
                                        ),
                                      ),
                                    ),
                            );
                          }
                          return Container();
                        },
                      );
                    },
                  );
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
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
