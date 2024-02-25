import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:PrimeTasche/controller/connection_controller.dart';
import 'package:PrimeTasche/main.dart';
import 'package:PrimeTasche/route_provider.dart';
import 'package:riverpod_context/riverpod_context.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

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
              "Admin",
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
              /*  Row(
                children: [
                  Gap(8),
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(8),
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(image: Image.asset("assets/images/moto.jpg").image, opacity: 1)),
                      ),
                      Text("Kurye Listesi")
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(8),
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                                scale: 0.5,
                                image: Image.asset(
                                  "assets/images/kutu2.png",
                                  width: 50,
                                  height: 50,
                                ).image,
                                opacity: 1)),
                      ),
                      Text("Kurye Listesi")
                    ],
                  )
                ],
              ),*/
              Container(
                margin: const EdgeInsets.all(16),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero, side: BorderSide(color: Colors.transparent))),
                    onPressed: () {
                      context.read(routeProvider).push("/kuryelist");
                    },
                    child: const SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Center(
                        child: Text(
                          "Kurye Listesi",
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
                      context.read(routeProvider).push("/teslimat");
                    },
                    child: const SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Center(
                        child: Text(
                          "Teslimat Listesi",
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
                      //context.read(bagListProvider).ver();
                      context.read(routeProvider).push("/baglist");
                    },
                    child: const SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Center(
                        child: Text(
                          "Çanta listesi",
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
                      context.read(routeProvider).push("/adminmappage");
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

class FirebaseAuth {}
