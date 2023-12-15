import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/controllers/auth_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/utils/error_screen.dart';
import 'app/utils/loading_screen.dart';
import 'app/utils/splash_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Future<FirebaseApp> _initialize = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authC = Get.put(AuthController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialize,
        builder: (context, snapshoot) {
          if (snapshoot.hasError) {
            return const ErrorScreen();
          }

          if (snapshoot.connectionState == ConnectionState.done) {
            return FutureBuilder(
              future: Future.delayed(const Duration(seconds: 3)),
              builder: (context, snapshoot) {
                if (snapshoot.connectionState == ConnectionState.done) {
                  return Obx(
                    () => GetMaterialApp(
                      title: "Chattie",
                      initialRoute: authC.isSkipIntro.isTrue
                          ? authC.isAuth.isTrue
                              ? Routes.HOME
                              : Routes.LOGIN
                          : Routes.INTRODUCTION,
                      getPages: AppPages.routes,
                    ),
                  );
                }
                return const SplashScreen();
              },
            );
          }
          return const LoadingScreen();
        });
  }
}
