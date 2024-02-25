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
              const Gap(30),
              const Text(
                "Hesabınızın türünü seçin",
                style: TextStyle(fontSize: 18, color: Colors.blueAccent),
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
                            child: const SizedBox(
                              width: 100,
                              child: Center(
                                child: Text(
                                  "Kurye",
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
                                child: Text("Admin"),
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
