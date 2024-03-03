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

class QrIslemPage extends StatelessWidget {
  const QrIslemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back),
        title: Text(
          container.read(languageProvider).isEnglish ? "Bag transactions." : "Taschenoperationen.",
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
                        context.read(bagListProvider).setSelectedBagQR(context.read(inputProvider).qr.text);
                        context.read(bagListProvider).depoyaAl();
                      },
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Center(
                          child: Text(
                              container.read(languageProvider).isEnglish
                                  ? "Put it in warehouse."
                                  : "Lagern Sie es ein.",
                              style: GoogleFonts.openSans(color: Colors.white, fontWeight: FontWeight.w500)),
                        ),
                      )),
                ),
                Gap(16),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero, side: BorderSide(color: Colors.transparent))),
                      onPressed: () async {
                        context.read(bagListProvider).setSelectedBagQR(context.read(inputProvider).qr.text);
                        if (context.read(bagListProvider).cantaVer()[context.read(bagListProvider).selectedBagQr] ==
                            null) {
                          showSimpleNotification(
                              Text(container.read(languageProvider).isEnglish
                                  ? "bag not found."
                                  : "Tasche nicht gefunden."),
                              background: Colors.blue);
                        } else {
                          context.read(routeProvider).push("/kuryesec");
                        }
                      },
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Center(
                          child: Text(
                              container.read(languageProvider).isEnglish
                                  ? "Give it to the courier."
                                  : "Geben Sie es dem Kurier.",
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
