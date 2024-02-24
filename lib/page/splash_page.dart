import 'package:flutter/material.dart';
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: Image.asset(
                  "assets/images/bck.jpg",
                ).image,
                opacity: 0.1)),
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
