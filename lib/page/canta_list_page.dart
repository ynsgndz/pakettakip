import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:PrimeTasche/controller/canta_list_controller.dart';
import 'package:PrimeTasche/controller/base_controller.dart';
import 'package:PrimeTasche/controller/kurye_controller.dart';
import 'package:PrimeTasche/route_provider.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:easy_refresh/easy_refresh.dart';

class BagListPage extends StatefulWidget {
  const BagListPage({super.key});

  @override
  State<BagListPage> createState() => _BagListPageState();
}

class _BagListPageState extends State<BagListPage> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // context.read(bagListProvider).getbags();
          context.read(routeProvider).push("/bagadd");
          context.read(routeProvider).push("/qrcamera");

          /*
          DatabaseReference ref = FirebaseDatabase.instance.ref("cantalar/123");

          try {
            await ref.set({
              "name": "John",
              "age": 18,
              "address": {"line1": "100 Mountain View"}
            });
          } on FirebaseException catch (a) {
            showSimpleNotification(Text(a.message ?? "Bilinmeyen Hata"), background: Colors.blue);
          }
          */
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
              "Çanta Listesi",
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
          Gap(8),
          Consumer(
            builder: (context, ref, child) {
              var kuryedeMi = ref.watch(bagListProvider).kurye;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.read(bagListProvider).kuryedeChange(true);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: kuryedeMi ? Colors.blue : Color.fromARGB(255, 240, 243, 250),
                          borderRadius: BorderRadius.circular(200),
                          boxShadow: [BoxShadow(color: Colors.grey.shade400, blurRadius: 1, offset: Offset(0, 1))]),
                      padding: EdgeInsets.all(8),
                      child: Text(
                        "Kuryeye Zimmetliler",
                        style: GoogleFonts.openSans(
                            color: kuryedeMi ? Colors.white : Color.fromARGB(240, 28, 96, 151),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Gap(8),
                  GestureDetector(
                    onTap: () {
                      context.read(bagListProvider).kuryedeChange(false);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: kuryedeMi ? Color.fromARGB(255, 240, 243, 250) : Colors.blue,
                          borderRadius: BorderRadius.circular(200),
                          boxShadow: [BoxShadow(color: Colors.grey.shade400, blurRadius: 1, offset: Offset(0, 1))]),
                      padding: EdgeInsets.all(8),
                      child: Text(
                        "Depodakiler",
                        style: GoogleFonts.openSans(
                            color: kuryedeMi ? Color.fromARGB(215, 50, 120, 181) : Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Gap(8),
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
                    var state = ref.watch(bagListProvider.select((value) => value.state));
                    ref.watch(bagListProvider.select((value) => value.kurye));
                    var cantalar = context.read(bagListProvider).kurye
                        ? context.read(bagListProvider).cantaKuryedeVer()
                        : context.read(bagListProvider).cantaDepodaVer();
                    if (state == DataState.loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (cantalar.isNotEmpty) {
                      return ListView.builder(
                        itemCount: cantalar.length,
                        itemBuilder: (context, index) {
                          return Container(
                            color: Colors.white,
                            margin: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                            child: ListTile(
                              title: Text(cantalar.keys.elementAt(index),
                                  style: GoogleFonts.openSans(color: Colors.blueAccent)),
                              subtitle: Row(
                                children: [
                                  Text(
                                      DateTime.fromMillisecondsSinceEpoch(int.parse(
                                              cantalar[cantalar.keys.elementAt(index)]?["timestamp"].toString() ?? "0"))
                                          .toString()
                                          .split(" ")
                                          .first,
                                      style: GoogleFonts.openSans()),
                                  Spacer(),
                                  Text(
                                      context
                                          .read(kuryeListProvider)
                                          .kuryeVer()
                                          .values
                                          .where((element) {
                                            return element["mail"] ==
                                                cantalar[context.read(bagListProvider).kurye
                                                        ? context
                                                            .read(bagListProvider)
                                                            .cantaKuryedeVer()
                                                            .keys
                                                            .elementAt(index)
                                                        : context
                                                            .read(bagListProvider)
                                                            .cantaDepodaVer()
                                                            .keys
                                                            .elementAt(index)]?["lastUser"]
                                                    .toString();
                                          })
                                          .toSet()
                                          .map((e) => e["name"])
                                          .toString()
                                          .replaceAll(")", "")
                                          .replaceAll("(", ""),
                                      style: GoogleFonts.openSans())
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state == DataState.loading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
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
