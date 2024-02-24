import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:pakettakip/controller/canta_list_controller.dart';
import 'package:pakettakip/controller/base_controller.dart';
import 'package:pakettakip/controller/connection_controller.dart';
import 'package:pakettakip/controller/info_controller.dart';
import 'package:pakettakip/controller/input_controller.dart';
import 'package:pakettakip/controller/map_controller.dart';
import 'package:pakettakip/main.dart';
import 'package:pakettakip/route_provider.dart';
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
            Container(
              width: 50,
              height: 50,
            ),
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
                    child: const SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Center(
                        child: Text(
                          "Çanta teslim et",
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
                    child: const SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Center(
                        child: Text(
                          "Çanta Teslim al",
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
                          "Harita",
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
                                              "Kuryede:${context.read(infoProvider).kuryede}",
                                              style: GoogleFonts.openSans(color: Colors.blue, fontSize: 18),
                                            ),
                                            const Gap(4),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Adreste:${context.read(infoProvider).adreste}",
                                              style: GoogleFonts.openSans(color: Colors.blue, fontSize: 18),
                                            ),
                                            const Gap(4),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Toplam:${context.read(infoProvider).adreste + context.read(infoProvider).kuryede}",
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
                                            "Tamam",
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
                          "İnfo",
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
                  return const Row(
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
                          "Lütfen uygulamayı kapatmayın sunuculara bağlandığında verileri eşitlenecek.",
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
