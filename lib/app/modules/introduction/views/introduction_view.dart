import 'package:chattie/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

import '../controllers/introduction_controller.dart';

class IntroductionView extends GetView<IntroductionController> {
  const IntroductionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            title: "Berinteraksi dengan mudah",
            body: "Kamu hanya perlu dirumah saja untuk mendapatkan teman baru",
            image: SizedBox(
              width: Get.width * 0.6,
              height: Get.width * 0.6,
              child: Center(
                child: Lottie.asset('assets/lottie/main-laptop-duduk.json'),
              ),
            ),
          ),
          PageViewModel(
            title: "Temukan Sahabat Baru",
            body:
                "Jika kamu memang jodoh karena aplikasi ini, kami sangat bahagia",
            image: SizedBox(
              width: Get.width * 0.6,
              height: Get.width * 0.6,
              child: Center(
                child: Lottie.asset('assets/lottie/ojek.json'),
              ),
            ),
          ),
          PageViewModel(
            title: "Aplikasi bebas biaya",
            body: "Kamu tidak perlu khawatir, aplikasi ini bebas biaya apapun",
            image: SizedBox(
              width: Get.width * 0.6,
              height: Get.width * 0.6,
              child: Center(
                child: Lottie.asset('assets/lottie/payment.json'),
              ),
            ),
          ),
          PageViewModel(
            title: "Gabung sekarang juga",
            body:
                "Daftarkan diri kamu untuk menjadi bagian dari kami. Kami akan menghubungkan dengan 1000 teman",
            image: SizedBox(
              width: Get.width * 0.6,
              height: Get.width * 0.6,
              child: Center(
                child: Lottie.asset('assets/lottie/register.json'),
              ),
            ),
          )
        ],
        showSkipButton: true,
        skip: const Text("Skip", style: TextStyle(fontWeight: FontWeight.w700)),
        next: const Text("Next", style: TextStyle(fontWeight: FontWeight.w700)),
        done:
            const Text("Login", style: TextStyle(fontWeight: FontWeight.w700)),
        onDone: () => Get.offAllNamed(Routes.LOGIN),
        dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: Theme.of(context).colorScheme.secondary,
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        ),
      ),
    );
  }
}
