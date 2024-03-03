import 'package:PrimeTasche/controller/language_controller.dart';
import 'package:PrimeTasche/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:PrimeTasche/controller/canta_list_controller.dart';
import 'package:PrimeTasche/controller/base_controller.dart';
import 'package:PrimeTasche/controller/kurye_controller.dart';
import 'package:PrimeTasche/route_provider.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:vibration/vibration.dart';
import 'package:visibility_detector/visibility_detector.dart';

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
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          if (context.read(bagListProvider).selectedIndex == -1) {
            context.read(routeProvider).pop();
          }
          context.read(bagListProvider).selectIndex(-1);
        }
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          floatingActionButton: Consumer(builder: (context, ref, asd) {
            var index = ref.watch(bagListProvider.select((value) => value.selectedIndex));
            if (index != -1) {
              Ticker((elapsed) {});
              return SpeedDial(
                overlayColor: Colors.white,
                overlayOpacity: 0.1,
                backgroundColor: Colors.blue,
                activeBackgroundColor: Colors.blue.shade200,
                children: [
                  SpeedDialChild(
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.change_circle_outlined,
                        color: Colors.white,
                      ),
                      onTap: () {
                        context.read(routeProvider).push("/kuryesec");
                      },
                      label: container.read(languageProvider).isEnglish
                          ? "Change the Courier"
                          : "den Fahrer zu wechseln."),
                  SpeedDialChild(
                      onTap: () {
                        context.read(bagListProvider).depoyaAl();
                      },
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.warehouse_outlined,
                        color: Colors.white,
                      ),
                      label: container.read(languageProvider).isEnglish ? "put it in Warehouse" : "einlagern.")
                ],
                child: Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
              );
            }

            return FloatingActionButton(
              onPressed: () {
                // context.read(bagListProvider).getbags();
                context.read(routeProvider).push("/bagadd");
                context.read(routeProvider).push("/qrcamera");
              },
              backgroundColor: Colors.blue,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            );
          }),
          appBar: AppBar(
            title: Row(
              children: [
                Text(
                  container.read(languageProvider).isEnglish ? "Bag List" : "Tasche List",
                  style: GoogleFonts.openSans(
                    fontSize: 20,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.delivery_dining_outlined),
                  text: container.read(languageProvider).isEnglish ? "On The Courier" : "Auf dem Fahrer",
                ),
                Tab(
                  icon: Icon(Icons.warehouse_outlined),
                  text: container.read(languageProvider).isEnglish ? "In the warehouse" : "Lagerhaus",
                ),
              ],
              onTap: (value) {
                context.read(bagListProvider).selectIndex(-1);
                print("tablandın");
              },
            ),
          ),
          body: TabBarView(children: [
            VisibilityDetector(
              key: Key("Test"),
              onVisibilityChanged: (info) {
                if (info.visibleFraction < 0.5) {
                  container.read(bagListProvider).selectIndex(-1);
                }
              },
              child: Stack(
                children: [
                  Container(
                      color: Colors.grey.shade100,
                      child: Consumer(
                        builder: (context, ref, child) {
                          var state = ref.watch(bagListProvider.select((value) => value.state));
                          ref.watch(bagListProvider.select((value) => value.kurye));
                          var cantalar = context.read(bagListProvider).cantaKuryedeVer();

                          if (state == DataState.loading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (cantalar.isNotEmpty) {
                            return ListView.builder(
                              itemCount: cantalar.length + 1,
                              itemBuilder: (context, index) {
                                if (index == cantalar.length) {
                                  return Container(
                                    height: 80,
                                  );
                                  // ignore: dead_code
                                  return Container(
                                    padding: EdgeInsets.only(left: 4),
                                    decoration:
                                        BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                    margin: EdgeInsets.all(8),
                                    height: 50,
                                    width: double.infinity,
                                    child: TextField(
                                      onChanged: (value) {},
                                      decoration: InputDecoration(
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          suffixIcon: Icon(Icons.search)),
                                    ),
                                  );
                                }

                                return Container(
                                  color: Colors.white,
                                  margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      context.read(bagListProvider).unselect();
                                    },
                                    onLongPress: () async {
                                      if (await Vibration.hasCustomVibrationsSupport() ?? false) {
                                        Vibration.vibrate(duration: 100);
                                      } else {
                                        Vibration.vibrate();
                                        await Future.delayed(Duration(milliseconds: 500));
                                        Vibration.vibrate();
                                      }
                                      context.read(bagListProvider).selectIndex(index);
                                      context.read(bagListProvider).setSelectedBagQR(cantalar.keys.elementAt(index));
                                    },
                                    child: Consumer(
                                      builder: (context, ref, child) {
                                        ref.watch(bagListProvider.select((value) => value.selectedIndex));
                                        return Container(
                                          color: context.read(bagListProvider).selectedIndex == index
                                              ? Colors.blue.shade100
                                              : Colors.white,
                                          child: ListTile(
                                            title: Text(cantalar.keys.elementAt(index),
                                                style: GoogleFonts.openSans(color: Colors.blueAccent)),
                                            subtitle: Row(
                                              children: [
                                                Text(
                                                    DateTime.fromMillisecondsSinceEpoch(int.parse(
                                                            cantalar[cantalar.keys.elementAt(index)]?["timestamp"]
                                                                    .toString() ??
                                                                "0"))
                                                        .toString()
                                                        .split(" ")
                                                        .first,
                                                    style: GoogleFonts.openSans()),
                                                const Spacer(),
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
                  Consumer(
                    builder: (context, ref, child) {
                      var index = ref.watch(bagListProvider.select((value) => value.selectedIndex));

                      if (index == -1) {
                        return Container();
                      }
                      if (!context.read(bagListProvider).kurye) {
                        return Container(
                          height: double.infinity,
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                      onPressed: () {},
                                      child: Text(
                                        container.read(languageProvider).isEnglish
                                            ? "Give it to the courier."
                                            : "Geben Sie es dem Fahrer",
                                        style: GoogleFonts.openSans(color: Colors.white),
                                      )),
                                ],
                              ),
                              Gap(8)
                            ],
                          ),
                        );
                      }

                      return Container(
                          /*
                        height: double.infinity,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                    onPressed: () {},
                                    child: Text(
                                      "Kurye değiştir",
                                      style: GoogleFonts.openSans(color: Colors.white),
                                    )),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                    onPressed: () {},
                                    child: Text(
                                      "Depoya al",
                                      style: GoogleFonts.openSans(color: Colors.white),
                                    )),
                              ],
                            ),
                            Gap(8)
                          ],
                        ),
                      */
                          );
                    },
                  )
                ],
              ),
            ),
            VisibilityDetector(
              key: Key("hello"),
              onVisibilityChanged: (info) {
                if (info.visibleFraction < 0.5) {
                  container.read(bagListProvider).selectIndex(-1);
                }
              },
              child: Container(
                  color: Colors.grey.shade100,
                  child: Consumer(
                    builder: (context, ref, child) {
                      var state = ref.watch(bagListProvider.select((value) => value.state));
                      ref.watch(bagListProvider.select((value) => value.kurye));
                      var cantalar = context.read(bagListProvider).cantaDepodaVer();
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
                              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                              child: GestureDetector(
                                onTap: () {
                                  context.read(bagListProvider).unselect();
                                },
                                onLongPress: () async {
                                  if (await Vibration.hasCustomVibrationsSupport() ?? false) {
                                    Vibration.vibrate(duration: 100);
                                  } else {
                                    Vibration.vibrate();
                                    await Future.delayed(Duration(milliseconds: 500));
                                    Vibration.vibrate();
                                  }
                                  context.read(bagListProvider).selectIndex(index);
                                  context.read(bagListProvider).setSelectedBagQR(cantalar.keys.elementAt(index));
                                },
                                child: Consumer(
                                  builder: (context, ref, child) {
                                    ref.watch(bagListProvider.select((value) => value.selectedIndex));
                                    return Container(
                                      color: context.read(bagListProvider).selectedIndex == index
                                          ? Colors.blue.shade100
                                          : Colors.white,
                                      child: ListTile(
                                        title: Text(cantalar.keys.elementAt(index),
                                            style: GoogleFonts.openSans(color: Colors.blueAccent)),
                                        subtitle: Row(
                                          children: [
                                            Text(
                                                DateTime.fromMillisecondsSinceEpoch(int.parse(
                                                        cantalar[cantalar.keys.elementAt(index)]?["timestamp"]
                                                                .toString() ??
                                                            "0"))
                                                    .toString()
                                                    .split(" ")
                                                    .first,
                                                style: GoogleFonts.openSans()),
                                            const Spacer(),
                                            Text(
                                                context
                                                    .read(kuryeListProvider)
                                                    .kuryeVer()
                                                    .values
                                                    .where((element) {
                                                      return element["mail"] ==
                                                          cantalar[context
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
                        return Container(
                          color: Colors.white,
                          child: Center(
                              child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.not_interested_sharp,
                                size: 50,
                                color: Colors.red,
                              ),
                              Text(
                                container.read(languageProvider).isEnglish
                                    ? "No bags in the warehouse"
                                    : "Keine Säcke im Lagerhaus",
                                style: GoogleFonts.openSans(color: Colors.blue, fontWeight: FontWeight.w500),
                              ),
                            ],
                          )),
                        );
                      }
                    },
                  )),
            ),
          ]),
        ),
      ),
    );
  }
}
