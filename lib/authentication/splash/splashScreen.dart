import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:login/authentication/module_choice/module_choice.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Center(
            child: LottieBuilder.asset(
                "assets/Lottie/Animation - 1710576989007.json"),
          )
        ],
      ),
      nextScreen: ModuleChoice(),
      splashIconSize: 500,
      backgroundColor: Color.fromARGB(255, 45, 48, 61),
    );
  }
}
