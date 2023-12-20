import 'package:get/get.dart';

import '../modules/change_profile/bindings/change_profile_binding.dart';
import '../modules/change_profile/views/change_profile_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/introduction/bindings/introduction_binding.dart';
import '../modules/introduction/views/introduction_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/search_person/bindings/search_person_binding.dart';
import '../modules/search_person/views/search_person_view.dart';
import '../modules/update_status/bindings/update_status_binding.dart';
import '../modules/update_status/views/update_status_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.INTRODUCTION,
      page: () => const IntroductionView(),
      binding: IntroductionBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH_PERSON,
      page: () => SearchPersonView(),
      binding: SearchPersonBinding(),
    ),
    GetPage(
      name: _Paths.UPDATE_STATUS,
      page: () => UpdateStatusView(),
      binding: UpdateStatusBinding(),
    ),
    GetPage(
      name: _Paths.CHANGE_PROFILE,
      page: () => ChangeProfileView(),
      binding: ChangeProfileBinding(),
    ),
  ];
}
