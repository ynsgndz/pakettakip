import 'package:PrimeTasche/controller/language_controller.dart';
import 'package:PrimeTasche/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:PrimeTasche/controller/canta_list_controller.dart';
import 'package:PrimeTasche/controller/base_controller.dart';
import 'package:PrimeTasche/controller/info_controller.dart';
import 'package:PrimeTasche/controller/kurye_controller.dart';
import 'package:PrimeTasche/route_provider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:riverpod_context/riverpod_context.dart';

class KuryeSecPage extends StatelessWidget {
  const KuryeSecPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Lütfen Kurye seçin",
              style: GoogleFonts.openSans(
                fontSize: 20,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey.shade100,
            width: double.infinity,
            height: 2,
          ),
          Expanded(
            child: Container(
                color: Colors.grey.shade100,
                child: Consumer(
                  builder: (context, ref, child) {
                    var kurye = ref.watch(kuryeListProvider).kuryeVer();
                    var state = ref.watch(kuryeListProvider.select((value) => value.state));

                    if (kurye.isNotEmpty) {
                      return ListView.builder(
                        itemCount: kurye.length,
                        itemBuilder: (context, index) {
                          context
                              .read(infoProvider)
                              .getInfoByMail(kurye[kurye.keys.elementAt(index)]["mail"].toString());
                          if (context.read(bagListProvider).cantaVer()[context.read(bagListProvider).selectedBagQr]
                                  ["lastUser"] ==
                              kurye[kurye.keys.elementAt(index)]["mail"]) {
                            return Container();
                          }

                          return Container(
                            margin: EdgeInsets.all(2),
                            color: Colors.white,
                            child: ListTile(
                              onTap: () {
                                context.read(bagListProvider).kuryeyeVer(kurye[kurye.keys.elementAt(index)]["mail"]);
                                context.read(routeProvider).pop();
                                context.read(routeProvider).pop();
                                context.read(routeProvider).push("/baglist");
                                if (context.read(routeProvider).canPop()) {
                                  context.read(routeProvider).pop();
                                }
                                //context.read(routeProvider).push("/baglist");
                              },
                              tileColor: Colors.white,
                              title: Text(
                                kurye[kurye.keys.elementAt(index)]?["name"].toString() ?? "0",
                                style: GoogleFonts.openSans(color: Colors.blueAccent),
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                      container.read(languageProvider).isEnglish
                                          ? "At the Adress: ${context.read(infoProvider).adreste}"
                                          : "Unter der Adresse: ${context.read(infoProvider).adreste}",
                                      style: GoogleFonts.openSans()),
                                  const Spacer(),
                                  Text(
                                      container.read(languageProvider).isEnglish
                                          ? "On The Courier: ${context.read(infoProvider).kuryede}"
                                          : "Auf dem Fahrer: ${context.read(infoProvider).kuryede}",
                                      style: GoogleFonts.openSans()),
                                  Spacer(),
                                  Text(
                                    "Total: ${context.read(infoProvider).kuryede + context.read(infoProvider).adreste}",
                                    style: GoogleFonts.openSans(),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state == DataState.loading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.amber,
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.amber,
                        ),
                      );
                    }
                  },
                )),
          ),
        ],
      ),
    );
  }
}
