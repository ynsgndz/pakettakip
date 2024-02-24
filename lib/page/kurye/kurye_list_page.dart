import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pakettakip/controller/canta_list_controller.dart';
import 'package:pakettakip/controller/base_controller.dart';
import 'package:pakettakip/controller/info_controller.dart';
import 'package:pakettakip/controller/kurye_controller.dart';
import 'package:pakettakip/route_provider.dart';
import 'package:riverpod_context/riverpod_context.dart';

class KuryeListPage extends StatelessWidget {
  const KuryeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read(routeProvider).push("/kuryeadd");
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Kurye Listesi",
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
                          return Container(
                            margin: EdgeInsets.all(2),
                            color: Colors.white,
                            child: ListTile(
                              tileColor: Colors.white,
                              title: Text(
                                kurye[kurye.keys.elementAt(index)]?["name"].toString() ?? "0",
                                style: GoogleFonts.openSans(color: Colors.blueAccent),
                              ),
                              subtitle: Row(
                                children: [
                                  Text("Adreste: ${context.read(infoProvider).adreste}", style: GoogleFonts.openSans()),
                                  const Spacer(),
                                  Text("Kuryede: ${context.read(infoProvider).kuryede}", style: GoogleFonts.openSans()),
                                  Spacer(),
                                  Text(
                                    "Toplam: ${context.read(infoProvider).kuryede + context.read(infoProvider).adreste}",
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
