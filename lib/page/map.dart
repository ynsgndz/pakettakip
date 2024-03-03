import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:PrimeTasche/controller/base_controller.dart';
import 'package:PrimeTasche/controller/map_controller.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read(mapProvider).konumuGetir();
      context.read(mapProvider).getNearMarkers();
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
      body: Consumer(
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
                userAgentPackageName: 'com.primetasche.app',
                tileProvider: FMTC.instance('mapStore').getTileProvider(),
                // Other parameters as normal
              ),
              MarkerLayer(markers: context.read(mapProvider).marker)
            ],
          );
        },
      ),
    );
  }
}
