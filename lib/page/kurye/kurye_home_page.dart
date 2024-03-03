import 'package:PrimeTasche/controller/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:PrimeTasche/controller/canta_list_controller.dart';
import 'package:PrimeTasche/controller/base_controller.dart';
import 'package:PrimeTasche/controller/connection_controller.dart';
import 'package:PrimeTasche/controller/info_controller.dart';
import 'package:PrimeTasche/controller/input_controller.dart';
import 'package:PrimeTasche/controller/map_controller.dart';
import 'package:PrimeTasche/main.dart';
import 'package:PrimeTasche/route_provider.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:latlong2/latlong.dart';

MapOptions? asd;

class KuryeHomePage extends StatefulWidget {
  const KuryeHomePage({super.key});

  @override
  State<KuryeHomePage> createState() => _KuryeHomePageState();
}

class _KuryeHomePageState extends State<KuryeHomePage> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            container.read(languageProvider).languageWidget,
            Text(
              auth.currentUser?.displayName ?? "",
              style: GoogleFonts.openSans(
                fontSize: 20,
                color: Colors.blue,
              ),
            ),
            IconButton(
                onPressed: () {
                  auth.signOut();
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.blue,
                )),
          ],
        ),
      ),
      body: Container(
        color: Colors.grey.shade100,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero, side: BorderSide(color: Colors.transparent))),
                    onPressed: () {
                      context.read(routeProvider).push("/kuryemap");
                      context.read(mapProvider).getNearMarkers();
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Center(
                        child: Text(
                          container.read(languageProvider).isEnglish ? "Deliver the bag" : "Die Tasche zu übergeben.",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )),
              ),
              Container(
                margin: const EdgeInsets.all(16),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero, side: BorderSide(color: Colors.transparent))),
                    onPressed: () {
                      context.read(inputProvider).qr.clear();
                      context.read(routeProvider).push("/cantateslimal");
                      context.read(routeProvider).push("/qrcamera");
                      context.read(mapProvider).konumuGetir();
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Center(
                        child: Text(
                          container.read(languageProvider).isEnglish ? "pick up the bag." : "Heben Sie die Tasche auf.",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )),
              ),
              Container(
                margin: const EdgeInsets.all(16),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero, side: BorderSide(color: Colors.transparent))),
                    onPressed: () {
                      context.read(routeProvider).push("/mappage");
                    },
                    child: const SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Center(
                        child: Text(
                          "Map",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )),
              ),
              Container(
                margin: const EdgeInsets.all(16),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero, side: BorderSide(color: Colors.transparent))),
                    onPressed: () {
                      context.read(infoProvider).getInfo().then(
                        (value) {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    backgroundColor: Colors.white,
                                    surfaceTintColor: Colors.white,
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context).size.width / 3,
                                            margin: const EdgeInsets.symmetric(horizontal: 16),
                                            child: Image.asset("assets/images/box.png")),
                                        const Gap(8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              container.read(languageProvider).isEnglish
                                                  ? "Courier:${context.read(infoProvider).kuryede}"
                                                  : "Fahrer:${context.read(infoProvider).kuryede}",
                                              style: GoogleFonts.openSans(color: Colors.blue, fontSize: 18),
                                            ),
                                            const Gap(4),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              container.read(languageProvider).isEnglish
                                                  ? "at the Adress:${context.read(infoProvider).adreste}"
                                                  : "unter der Adresse:${context.read(infoProvider).adreste}",
                                              style: GoogleFonts.openSans(color: Colors.blue, fontSize: 18),
                                            ),
                                            const Gap(4),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              container.read(languageProvider).isEnglish
                                                  ? "Total:${context.read(infoProvider).adreste + context.read(infoProvider).kuryede}"
                                                  : "Total:${context.read(infoProvider).adreste + context.read(infoProvider).kuryede}",
                                              style: GoogleFonts.openSans(color: Colors.blue, fontSize: 18),
                                            ),
                                            const Gap(4),
                                          ],
                                        ),
                                        const Gap(8),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                          onPressed: () {
                                            context.pop();
                                          },
                                          child: Text(
                                            "OK",
                                            style: GoogleFonts.openSans(color: Colors.white, fontSize: 18),
                                          ),
                                        )
                                      ],
                                    ));
                              });
                        },
                      );
                    },
                    child: const SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Center(
                        child: Text(
                          "Info",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )),
              ),
              const Gap(16),
              Consumer(
                builder: (context, ref, child) {
                  var connected = ref.watch(connectionProvider.select((value) => value.connected));
                  if (connected) {
                    return Container();
                  }
                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Gap(16),
                      Icon(
                        Icons.info_outline,
                        color: Colors.red,
                      ),
                      Gap(8),
                      Expanded(
                        child: Text(
                          container.read(languageProvider).isEnglish
                              ? "Please do not close the app, it will synchronize the data when it connects to the servers. "
                              : "Bitte schließen Sie die Anwendung nicht, ihre Daten werden synchronisiert, wenn sie sich mit den Servern verbindet.",
                        ),
                      )
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
