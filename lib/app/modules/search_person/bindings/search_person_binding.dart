import 'package:get/get.dart';

import '../controllers/search_person_controller.dart';

class SearchPersonBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchPersonController>(
      () => SearchPersonController(),
    );
  }
}
