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

class BagAddPage extends StatelessWidget {
  const BagAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          container.read(languageProvider).isEnglish ? "Add the bag" : "Tasche hinzufügen",
          style: GoogleFonts.openSans(color: Colors.blue, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Gap(MediaQuery.of(context).size.height / 15),
            Container(
                width: MediaQuery.of(context).size.width / 3,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Image.asset("assets/images/box.png")),
            const Gap(40),
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
            const Gap(16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 60,
              child: TextField(
                controller: context.read(inputProvider).cantaPass,
                decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.password,
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

                    if (context.read(bagListProvider).cantaVer().containsKey(container.read(inputProvider).qr.text)) {
                      showSimpleNotification(
                          Text(container.read(languageProvider).isEnglish
                              ? "You added this bag earlier."
                              : "Sie haben diese Tasche vorhin hinzugefügt."),
                          background: Colors.blue);
                    } else {
                      if (context.read(inputProvider).qr.text.isEmpty) {
                        showSimpleNotification(
                            Text(container.read(languageProvider).isEnglish
                                ? "The QR section cannot be left blank."
                                : "Der QR-Teil kann nicht leer gelassen werden."),
                            background: Colors.blue);
                        return;
                      }
                      if (context.read(inputProvider).cantaPass.text.isEmpty) {
                        showSimpleNotification(
                            Text(container.read(languageProvider).isEnglish
                                ? "The password section cannot be left blank."
                                : "Das Feld für das Kennwort kann nicht leer gelassen werden."),
                            background: Colors.blue);
                        return;
                      }

                      try {
                        await ref.set({
                          "timestamp": DateTime.now().millisecondsSinceEpoch,
                          "inAdress": false,
                          "inCourier": false,
                          "lastUser": auth.currentUser?.email ?? "",
                          "location": {"lat": 0, "lon": 0},
                          "pass": context.read(inputProvider).cantaPass.text
                        });
                        showSimpleNotification(
                            Text(
                              container.read(languageProvider).isEnglish
                                  ? "Bag Successfully Added"
                                  : "Tasche erfolgreich angebracht",
                              style: GoogleFonts.openSans(color: Colors.white),
                            ),
                            background: Colors.blue);
                        context.read(inputProvider).qr.clear();
                        context.read(inputProvider).cantaPass.clear();
                      } on FirebaseException catch (a) {
                        showSimpleNotification(Text(a.message ?? "Bilinmeyen Hata"), background: Colors.blue);
                      }
                    }
                  },
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Center(
                      child: Text(
                        container.read(languageProvider).isEnglish ? "Add" : "Hinzufügen",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
