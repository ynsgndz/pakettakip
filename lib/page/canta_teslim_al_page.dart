import 'package:PrimeTasche/controller/language_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:PrimeTasche/controller/canta_list_controller.dart';
import 'package:PrimeTasche/controller/input_controller.dart';
import 'package:PrimeTasche/main.dart';
import 'package:PrimeTasche/route_provider.dart';
import 'package:riverpod_context/riverpod_context.dart';

var auth = FirebaseAuth.instance;

class CantaTeslimAlPage extends StatelessWidget {
  const CantaTeslimAlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back),
        title: Text(
          container.read(languageProvider).isEnglish ? "Pick up the bag" : "Nehmen Sie die Tasche.",
          style: GoogleFonts.openSans(color: Colors.blue, fontSize: 20),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 90,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width / 3,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Image.asset("assets/images/box.png")),
                const Gap(20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 60,
                  child: TextField(
                    controller: context.read(inputProvider).qr,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.qr_code,
                          color: Colors.blueAccent,
                          size: 25,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            context.read(routeProvider).push("/qrcamera");
                          },
                          icon: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.black,
                            size: 25,
                          ),
                        ),
                        isDense: true,
                        contentPadding: const EdgeInsets.all(16),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent, width: 1),
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blueAccent,
                            width: 1,
                          ),
                        ),
                        fillColor: Colors.white,
                        filled: true),
                  ),
                ),
                const Gap(32),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero, side: BorderSide(color: Colors.transparent))),
                      onPressed: () async {
                        DatabaseReference ref =
                            FirebaseDatabase.instance.ref("cantalar/${container.read(inputProvider).qr.text}");

                        try {
                          if (context
                              .read(bagListProvider)
                              .cantaVer()
                              .containsKey(context.read(inputProvider).qr.text)) {
                            print("var");
                            var temp = context.read(bagListProvider).cantaVer()[context.read(inputProvider).qr.text];
                            /* if (temp["lastUser"] != auth.currentUser!.email) {
                              showSimpleNotification(const Text("Bu çanta size kayıtlı değil"), background: Colors.blue);
                              return;
                            }*/
                            if (temp["inAdress"] == false && temp["inCourier"] == true) {
                              showSimpleNotification(
                                  Text(container.read(languageProvider).isEnglish
                                      ? "This bag has already been picked up."
                                      : "Diese Tasche ist bereits abgeholt worden."),
                                  background: Colors.blue);
                              context.read(routeProvider).pop();
                              return;
                            }
                            context.read(routeProvider).pop();
                            ref.update({
                              "timestamp": DateTime.now().millisecondsSinceEpoch,
                              "inAdress": false,
                              "inCourier": true,
                              "lastUser": auth.currentUser!.email,
                              "location": {"lat": 0, "lon": 0},
                              "packetNo": ""
                            });

                            var cantalarTemp = container.read(bagListProvider).cantaVer();
                            int tempSayi = 0;

                            cantalarTemp.forEach((key, value) {
                              if (value["inCourier"] && value["lastUser"] == auth.currentUser!.email.toString()) {
                                tempSayi++;
                              }
                            });

                            showSimpleNotification(
                                Text(container.read(languageProvider).isEnglish
                                    ? "You have ${tempSayi + 1} bags"
                                    : "Sie haben ${tempSayi + 1} Taschen"),
                                background: Colors.blue);
                          } else {
                            showSimpleNotification(
                                Text(container.read(languageProvider).isEnglish
                                    ? "This QR code is not recognized in the system."
                                    : "Dieser QR-Code wird vom System nicht erkannt."),
                                background: Colors.blue);
                          }
                        } on FirebaseException catch (a) {
                          showSimpleNotification(Text(a.message ?? "Bilinmeyen Hata"), background: Colors.blue);
                        }
                      },
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Center(
                          child: Text(
                              container.read(languageProvider).isEnglish ? "Pick up the bag" : "Nehmen Sie die Tasche.",
                              style: GoogleFonts.openSans(color: Colors.white, fontWeight: FontWeight.w500)),
                        ),
                      )),
                ),
                Gap(32)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
