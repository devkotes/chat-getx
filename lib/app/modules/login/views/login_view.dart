import 'package:chattie/app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({super.key});

  final authC = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: context.width * 0.7,
                  height: context.width * 0.7,
                  child: Lottie.asset('assets/lottie/login.json'),
                ),
                const SizedBox(
                  height: 150,
                ),
                ElevatedButton(
                  onPressed: () => authC.login(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[900],
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: Image.asset('assets/logo/google.png'),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      const Text(
                        'Sign in with Google',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Text('Chattie Getx'),
                const Text('v.1.0.0'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
