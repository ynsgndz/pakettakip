import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pakettakip/controller/input_controller.dart';
import 'package:pakettakip/main.dart';
import 'package:riverpod_context/riverpod_context.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 35,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Giriş yapın",
                    style: GoogleFonts.openSans(color: Colors.blue, fontSize: 30),
                  ),
                  Gap(30),
                  Container(
                      width: MediaQuery.of(context).size.width / 3,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Image.asset("assets/images/box.png")),
                  Gap(8),

                  /*  CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    radius: MediaQuery.of(context).size.width / 5,
                    child: Container(
                        width: MediaQuery.of(context).size.width / 4,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Image.asset(
                          "assets/images/profil.png",
                          color: Colors.white,
                        )),
                  ),*/
                  /*   const Text(
                    "Giriş Yapın",
                    style: TextStyle(fontSize: 30, color: Colors.blueAccent),
                  ),*/
                  /*
                  const CircleAvatar(
                    radius: 50,
                    child: Icon(
                      Icons.person_outline,
                      size: 60,
                    ),
                  ),
                 */
                  const Gap(16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 50,
                    child: TextField(
                      controller: context.read(inputProvider).mail,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: Colors.blueAccent,
                            size: 30,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.all(16),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent, width: 1),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent, width: 1),
                          ),
                          fillColor: Colors.white,
                          filled: true),
                    ),
                  ),
                  const Gap(20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 50,
                    child: TextField(
                      controller: context.read(inputProvider).pass,
                      obscureText: true,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Colors.blueAccent,
                            size: 25,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.all(16),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent, width: 1),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blueAccent,
                              width: 1,
                            ),
                          ),
                          fillColor: Colors.white,
                          filled: true),
                    ),
                  ),
                  const Gap(40),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero, side: BorderSide(color: Colors.transparent))),
                        onPressed: () async {
                          try {
                            await auth.signInWithEmailAndPassword(
                                email: context.read(inputProvider).mail.text,
                                password: context.read(inputProvider).pass.text);
                          } on FirebaseAuthException catch (e) {
                             showSimpleNotification(Text("Mail veya şifre yanlış."), background: Colors.blue);
                          }
                        },
                        child: const SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: Center(
                            child: Text(
                              "Giriş Yap",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )),
                  ),
                  Gap(30)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
