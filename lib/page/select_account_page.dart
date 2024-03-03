import 'package:PrimeTasche/controller/language_controller.dart';
import 'package:PrimeTasche/main.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:PrimeTasche/route_provider.dart';
import 'package:riverpod_context/riverpod_context.dart';

class AccountSelectPage extends StatelessWidget {
  const AccountSelectPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: Image.asset(
              "assets/images/bck.jpg",
            ).image,
          )),
          child: Column(
            children: [
              Gap(30),
              Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(container.read(languageProvider).isEnglish?
                        "Select the type of your account":"Wählen Sie die Art Ihres Kontos",
                        style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [context.read(languageProvider).languageWidget, Gap(20)],
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2),
                                    side: const BorderSide(color: Colors.transparent))),
                            onPressed: () {
                              context.read(routeProvider).push("/login");
                              /*
                              auth.signInWithEmailAndPassword(
                                  email: context.read(inputProvider).mail.text,
                                  password: context.read(inputProvider).pass.text);
                           */
                            },
                            child:  SizedBox(
                              width: 100,
                              child: Center(
                                child: Text(
                                  container.read(languageProvider).isEnglish?
                                  "Courier":"Fahrer",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2),
                                    side: const BorderSide(color: Colors.transparent))),
                            onPressed: () {
                              context.read(routeProvider).push("/login");
                              /*
                             
                           */
                            },
                            child: const SizedBox(
                              width: 100,
                              child: Center(
                                child: Text("Mod"),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(35)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
