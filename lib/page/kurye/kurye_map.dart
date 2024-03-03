import 'package:PrimeTasche/controller/language_controller.dart';
import 'package:PrimeTasche/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:PrimeTasche/controller/base_controller.dart';
import 'package:PrimeTasche/controller/input_controller.dart';
import 'package:PrimeTasche/controller/map_controller.dart';
import 'package:PrimeTasche/route_provider.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:latlong2/latlong.dart';

class KuryeMap extends StatefulWidget {
  const KuryeMap({super.key});

  @override
  State<KuryeMap> createState() => _CantaTeslimEtPageState();
}

class _CantaTeslimEtPageState extends State<KuryeMap> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read(mapProvider).konumuGetir();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("build alındı");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          container.read(languageProvider).isEnglish?
          "Please select the Location":"Bitte wählen Sie Ihren Standort.",
          style: GoogleFonts.openSans(color: Colors.blue, fontSize: 18),
        ),
      ),
      body: Stack(
        children: [
          Consumer(
            builder: (context, ref, child) {
              var state = ref.watch(mapProvider.select((value) => value.state));
              print(state.toString());
              if (state != DataState.data) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(context.read(mapProvider).myLocation?.latitude ?? 0,
                        context.read(mapProvider).myLocation?.longitude ?? 0),
                    onPositionChanged: (position, hasGesture) {
                      context.read(mapProvider).changePosition(position);
                      print("konum=>");
                      print(position.center!.latitude.toString());
                    },
                    initialZoom: 18,
                    interactionOptions: const InteractionOptions(flags: ~InteractiveFlag.rotate),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.primetasche.app',
                      tileProvider: FMTC.instance('mapStore').getTileProvider(),
                      // Other parameters as normal
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        ref.watch(mapProvider.select((value) => value.state));
                        return MarkerLayer(markers: context.read(mapProvider).marker);
                      },
                    )
                  ],
                );
              }
            },
          ),
          const Center(
            child: Icon(
              Icons.location_on,
              size: 30,
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              // ref.watch(mapProvider.select((value) => value.position.center?.latitude ?? 0));
              return Container(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          context.read(routeProvider).push("/cantateslimet");
                          context.read(inputProvider).qr.clear();
                          context.read(routeProvider).push("/qrcamera");
                        },
                        child: Text(
                          container.read(languageProvider).isEnglish?
                          "Select":
                          "Wählen Sie",
                          style: GoogleFonts.openSans(),
                        )),
                    Gap(8)
                    /*
                    Text(
                        "${context.read(mapProvider).position.center?.latitude.toString() ?? "null"} , ${context.read(mapProvider).position.center?.latitude.toString() ?? "null"}")
                  */
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
