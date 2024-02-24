import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pakettakip/controller/base_controller.dart';
import 'package:pakettakip/controller/kurye_controller.dart';
import 'package:pakettakip/controller/map_controller.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:latlong2/latlong.dart';

class AdminMapPage extends StatefulWidget {
  const AdminMapPage({super.key});

  @override
  State<AdminMapPage> createState() => _MapPageState();
}

class _MapPageState extends State<AdminMapPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read(mapProvider).konumuGetir();
      context.read(mapProvider).getMarkers();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(context.read(mapProvider).myLocation?.latitude);
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Harita",
        style: GoogleFonts.openSans(color: Colors.blue),
      )),
      body: Stack(
        children: [
          Consumer(
            builder: (context, ref, child) {
              var state = ref.watch(mapProvider.select((value) => value.state));

              if (state == DataState.loading) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(context.read(mapProvider).myLocation?.latitude ?? 0,
                      context.read(mapProvider).myLocation?.longitude ?? 0),
                  initialZoom: 17,
                  interactionOptions: const InteractionOptions(flags: ~InteractiveFlag.rotate),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.yemekqr.pakettakip',
                    tileProvider: FMTC.instance('mapStore').getTileProvider(),
                    // Other parameters as normal
                  ),
                  MarkerLayer(markers: context.read(mapProvider).marker)
                ],
              );
            },
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Consumer(
                builder: (context, ref, child) {
                  var pin = ref.watch(mapProvider.select((value) => value.pinler));
                  print(pin);
                  print("hello");
                  print(pin);
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                    width: double.infinity,
                    child: pin.length > 0
                        ? Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Kurye Adı: ",
                                    style: GoogleFonts.openSans(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    context
                                        .read(kuryeListProvider)
                                        .kuryeVer()
                                        .values
                                        .where((element) {
                                          return element["mail"] == pin["lastUser"].toString();
                                        })
                                        .toSet()
                                        .map((e) => e["name"])
                                        .toString()
                                        .replaceAll(")", "")
                                        .replaceAll("(", ""),
                                    style: GoogleFonts.openSans(color: Colors.blue),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("QR kod: ", style: GoogleFonts.openSans(fontWeight: FontWeight.w600)),
                                  Text(
                                    context.read(mapProvider).getKey(),
                                    style: GoogleFonts.openSans(color: Colors.blue),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Teslim tarihi: ",
                                    style: GoogleFonts.openSans(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                      "${DateTime.fromMillisecondsSinceEpoch(pin["timestamp"]).toString().split(":")[0]}:${DateTime.fromMillisecondsSinceEpoch(pin["timestamp"]).toString().split(":")[1]}",
                                      style: GoogleFonts.openSans(color: Colors.blue)),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Şifre: ",
                                    style: GoogleFonts.openSans(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "${pin["pass"]}",
                                    style: GoogleFonts.openSans(color: Colors.blue),
                                  )
                                ],
                              ),
                            ],
                          )
                        : Center(
                            child: Text(
                              "Detaylar için haritada pinlere dokunun.",
                              style: GoogleFonts.openSans(color: Colors.blue),
                            ),
                          ),
                  );
                },
              ),
              Container(
                height: 5,
                width: double.infinity,
                color: Colors.transparent,
              )
            ],
          ),
        ],
      ),
    );
  }
}
