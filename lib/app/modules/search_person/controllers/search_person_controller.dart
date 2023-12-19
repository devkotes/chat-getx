import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPersonController extends GetxController {
  late TextEditingController searchC;

  var queryAwal = [].obs;
  var tempSearch = [].obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    searchC = TextEditingController();
    super.onInit();
  }

  Future<void> searchFriend(
      {required String search, required String email}) async {
    debugPrint('SEARCH : $search');

    if (search.isEmpty) {
      queryAwal.value = [];
      tempSearch.value = [];
    } else {
      var capitalized =
          search.substring(0, 1).toUpperCase() + search.substring(1);

      if (queryAwal.isEmpty && search.length == 1) {
        CollectionReference users = firestore.collection('users');
        final keyNameResult = await users
            .where("keyName", isEqualTo: search.substring(0, 1).toUpperCase())
            .where('email', isNotEqualTo: email)
            .get();

        debugPrint('TOTAL DATA : ${keyNameResult.docs.length}');

        if (keyNameResult.docs.isNotEmpty) {
          for (var i = 0; i < keyNameResult.docs.length; i++) {
            queryAwal.add(keyNameResult.docs[i].data() as Map<String, dynamic>);
          }
          debugPrint('Query Result : $queryAwal');
        } else {
          debugPrint('Tidak ada data');
        }
      }

      if (queryAwal.isNotEmpty) {
        tempSearch.value = [];
        for (var element in queryAwal) {
          if (element['name'].toString().startsWith(capitalized)) {
            tempSearch.add(element);
          }
        }
      }
    }

    queryAwal.refresh();
    tempSearch.refresh();
  }

  @override
  void onClose() {
    searchC.dispose();
    super.onClose();
  }
}
