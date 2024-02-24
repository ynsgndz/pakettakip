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
import 'package:easy_refresh/easy_refresh.dart';

class TeslimatListPage extends StatefulWidget {
  const TeslimatListPage({super.key});

  @override
  State<TeslimatListPage> createState() => _BagListPageState();
}

class _BagListPageState extends State<TeslimatListPage> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Teslimat Listesi",
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
                    var cantalar = context.read(bagListProvider).cantaTeslimattaVer();
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
                            color: context.read(bagListProvider).renkVer(DateTime.fromMillisecondsSinceEpoch(
                                int.parse(cantalar[cantalar.keys.elementAt(index)]?["timestamp"].toString() ?? "0"))),
                            margin: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                            child: ListTile(
                              title: Text(cantalar.keys.elementAt(index)),
                              subtitle: Row(
                                children: [
                                  Text(DateTime.fromMillisecondsSinceEpoch(int.parse(
                                              cantalar[cantalar.keys.elementAt(index)]?["timestamp"].toString() ?? "0"))
                                          .toString()
                                          .split(":")[0] +
                                      ":" +
                                      DateTime.fromMillisecondsSinceEpoch(int.parse(
                                              cantalar[cantalar.keys.elementAt(index)]?["timestamp"].toString() ?? "0"))
                                          .toString()
                                          .split(":")[1]),
                                  Spacer(),
                                  Text(context
                                      .read(kuryeListProvider)
                                      .kuryeVer()
                                      .values
                                      .where((element) {
                                        return element["mail"] ==
                                            cantalar[context
                                                    .read(bagListProvider)
                                                    .cantaTeslimattaVer()
                                                    .keys
                                                    .elementAt(index)]?["lastUser"]
                                                .toString();
                                      })
                                      .toSet()
                                      .map((e) => e["name"])
                                      .toString()
                                      .replaceAll(")", "")
                                      .replaceAll("(", ""))
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
