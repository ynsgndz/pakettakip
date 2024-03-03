import 'package:PrimeTasche/controller/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:location/location.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:PrimeTasche/controller/canta_list_controller.dart';
import 'package:PrimeTasche/controller/base_controller.dart';
import 'package:latlong2/latlong.dart';
import 'package:PrimeTasche/main.dart';

String packetKey = "";

class MapController extends BaseController {
  LocationData? myLocation;
  MapPosition position = const MapPosition(center: LatLng(0, 0));
  List<Marker> marker = [];
  Map<dynamic, dynamic> pinler = {};

  int _triger = 0;
  void konumuGetir() async {
    state = DataState.loading;
    final Location location = Location();
    myLocation = await location.getLocation();
    position = MapPosition(center: LatLng(myLocation?.latitude ?? 0, myLocation?.longitude ?? 0));
    if (auth.currentUser!.uid != "KgudjIDXmtdp3zke7WWANtbRXUv1") {
      getNearMarkers();
    } else {
      getMarkers();
    }

    state = DataState.data;
  }

  void changePosition(MapPosition pos) {
    position = pos;
    buildCek();
  }

  String getKey() {
    return packetKey;
  }

  void getMarkers() {
    print("genel marker.........................................................................................");
    marker.clear();
    if (myLocation == null) {
      // showSimpleNotification(Text("Konum alma hatası"), background: Colors.blue);
      return;
    }

    var asd = container.read(bagListProvider).cantaVer();
    asd.forEach((key, value) {
      _triger = 0;
      var deneme = value;
      print(value["location"]);
      if (value["inAdress"]) {
        marker.add(Marker(
            height: 60,
            width: 40,
            point: LatLng(
                double.parse(value["location"]["lat"].toString()), double.parse(value["location"]["lon"].toString())),
            child: GestureDetector(
              onTap: () {
                pinler = value;
                packetKey = key;
                notifyListeners();
              },
              child: Consumer(
                builder: (context, ref, child) {
                  ref.watch(mapProvider.select((value) => value.pinler));
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: packetKey == key ? Colors.blue : Colors.transparent,
                        child: Icon(
                          Icons.location_on,
                          color: container
                                      .read(bagListProvider)
                                      .renkVer(DateTime.fromMillisecondsSinceEpoch(value["timestamp"])) ==
                                  Colors.white
                              ? Colors.blue
                              : container
                                  .read(bagListProvider)
                                  .renkVer(DateTime.fromMillisecondsSinceEpoch(value["timestamp"])),
                          size: 40,
                        ),
                      ),
                    ],
                  );
                },
              ),
            )));
      }
    });
    buildCek();
  }

  void getNearMarkers() {
    _triger = 0;
    marker.clear();
    if (myLocation == null) {
      // showSimpleNotification(Text("Konum alma hatası"), background: Colors.blue);
      return;
    }

    var asd = container.read(bagListProvider).cantaVer();
    asd.forEach(
      (key, value) {
        _triger = 0;
        print(value["location"]);
        if (value["inAdress"]) {
          double lonDistance =
              double.parse(value["location"]["lon"].toString()) - double.parse(myLocation!.longitude.toString());
          double latDistance =
              double.parse(value["location"]["lat"].toString()) - double.parse(myLocation!.latitude.toString());

          if (lonDistance * lonDistance < 0.000001) {
            print("lot yakın");
            _triger++;
          }
          if (latDistance * latDistance < 0.000001) {
            print("lat yakın");
            _triger++;
          }

          if (container.read(bagListProvider).renkVer(DateTime.fromMillisecondsSinceEpoch(value["timestamp"])) !=
              Colors.white) {
            if (_triger == 2) {
              showSimpleNotification(
                  Text(container.read(languageProvider).isEnglish
                      ? "There's a bag to be picked up within 100 meters."
                      : "Innerhalb von 100 Metern ist eine Tasche abzuholen."),
                  background: Colors.red,
                  duration: Duration(seconds: 5));
              _triger++;
            }
            marker.add(Marker(
                point: LatLng(double.parse(value["location"]["lat"].toString()),
                    double.parse(value["location"]["lon"].toString())),
                child: Icon(
                  Icons.location_on,
                  color:
                      container.read(bagListProvider).renkVer(DateTime.fromMillisecondsSinceEpoch(value["timestamp"])),
                  size: 40,
                )));
          }
        }
      },
    );
    buildCek();
  }

  void buildCek() {
    state = DataState.initial;
    state = DataState.data;
  }
}

final mapProvider = ChangeNotifierProvider<MapController>((_) => MapController());
