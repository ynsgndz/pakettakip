import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pakettakip/controller/canta_list_controller.dart';
import 'package:pakettakip/controller/input_controller.dart';
import 'package:pakettakip/controller/map_controller.dart';
import 'package:pakettakip/main.dart';
import 'package:pakettakip/route_provider.dart';
import 'package:riverpod_context/riverpod_context.dart';

var auth = FirebaseAuth.instance;

class CantaTeslimEtPage extends StatelessWidget {
  const CantaTeslimEtPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back),
        title: Text(
          "Çanta Teslim et",
          style: GoogleFonts.openSans(color: Colors.blue, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Gap(MediaQuery.of(context).size.height / 15),
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
            const Gap(16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 60,
              child: TextField(
                controller: context.read(inputProvider).paketNo,
                decoration: InputDecoration(
                    hintText: "Paket Numarası",
                    hintStyle: GoogleFonts.openSans(),
                    prefixIcon: const Icon(
                      Icons.numbers,
                      color: Colors.blueAccent,
                      size: 25,
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
                    if (context.read(mapProvider).position.center == null) {
                      showSimpleNotification(const Text("Konum Seçme hatası"), background: Colors.blue);
                      return;
                    }
                    if (context.read(inputProvider).paketNo.text.length < 1) {
                      showSimpleNotification(const Text("Paket numarası boş geçilemez."), background: Colors.blue);
                      return;
                    }

                    try {
                      context.read(bagListProvider).cantaVer().forEach((key, value) {
                        print(value);
                      });

                      if (context.read(bagListProvider).cantaVer().containsKey(container.read(inputProvider).qr.text)) {
                        print("var");
                        var temp = context.read(bagListProvider).cantaVer()[container.read(inputProvider).qr.text];

                        if (temp["lastUser"] != auth.currentUser!.email) {
                          showSimpleNotification(const Text("Bu çanta size kayıtlı değil"), background: Colors.blue);
                          return;
                        }

                        if (temp["inAdress"] == true) {
                          showSimpleNotification(const Text("Çanta zaten bir adreste kayıtlı"),
                              background: Colors.blue);
                          return;
                        }

                        ref.update({
                          "timestamp": DateTime.now().millisecondsSinceEpoch,
                          "inAdress": true,
                          "inCourier": false,
                          "lastUser": auth.currentUser!.email,
                          "location": {
                            "lat": context.read(mapProvider).position.center!.latitude,
                            "lon": context.read(mapProvider).position.center!.longitude
                          },
                          "packetNo": context.read(inputProvider).paketNo.text
                        });

                        var cantalarTemp = container.read(bagListProvider).cantaVer();
                        int tempSayi = 0;

                        cantalarTemp.forEach((key, value) {
                          if (value["inCourier"] && value["lastUser"] == auth.currentUser!.email.toString()) {
                            tempSayi++;
                          }
                        });

                        print("sayi bu=<$tempSayi");
                        if (tempSayi < 10) {
                          showSimpleNotification(Text("Çanta Miktarınız azalıyor.(${tempSayi - 1})"),
                              background: Colors.red, duration: const Duration(seconds: 8));
                        }

                        // context.read(routeProvider).pop();
                        //  context.read(routeProvider).pop();
                        sifreyiGoster(context, temp);
                      } else {
                        showSimpleNotification(const Text("Bu QR kodu sistemde tanımlı değil."),
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
                      child: Text("Teslim Et",
                          style: GoogleFonts.openSans(color: Colors.white, fontWeight: FontWeight.w500)),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> sifreyiGoster(BuildContext context, Map<dynamic, dynamic> tempMap) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width / 3,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Image.asset("assets/images/box.png")),
                  Gap(4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          "Şifreyi not edip müşterinin posta kutusuna atın.",
                          style: GoogleFonts.openSans(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  Gap(4),
                  Text(
                    "Çanta No:${context.read(inputProvider).qr.text}",
                    style: GoogleFonts.openSans(color: Colors.blue, fontSize: 18),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Şifre:",
                        style: GoogleFonts.openSans(color: Colors.blue, fontSize: 18),
                      ),
                      const Gap(4),
                      Text(
                        tempMap["pass"],
                        style: GoogleFonts.openSans(color: Colors.blue, fontSize: 25, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const Gap(8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () {
                       context.pop();
                      context.read(routeProvider).pop();
                      context.read(routeProvider).pop();
                    },
                    child: Text(
                      "Tamam",
                      style: GoogleFonts.openSans(color: Colors.white, fontSize: 18),
                    ),
                  )
                ],
              ));
        });
  }
}
