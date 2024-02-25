import 'package:PrimeTasche/controller/base_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';


Map<dynamic, dynamic> cantalarListe = {};
Map<dynamic, dynamic> cantalarKuryedeListe = {};
Map<dynamic, dynamic> cantalarDepodaListe = {};
Map<dynamic, dynamic> cantalarTeslimatListe = {};
bool flag = true;

class BagListController extends BaseController {
  bool kurye = true;
  static Future<UserCredential?> register(String email, String password) async {
    UserCredential? userCredential;
    FirebaseApp app = await Firebase.initializeApp(name: 'Secondary', options: Firebase.app().options);
    try {} on FirebaseAuthException catch (e) {
      showSimpleNotification(Text(e.message ?? "Bilinmeyen Hata"), background: Colors.blue);
    }

    await app.delete();

    return userCredential;
  }

  Map<dynamic, dynamic> cantaVer() {
    return cantalarListe;
  }

  Map<dynamic, dynamic> cantaDepodaVer() {
    return cantalarDepodaListe;
  }

  Map<dynamic, dynamic> cantaKuryedeVer() {
    return cantalarKuryedeListe;
  }

  Map<dynamic, dynamic> cantaTeslimattaVer() {
    return cantalarTeslimatListe;
  }

  void kuryedeChange(bool newState) {
    kurye = newState;
    notifyListeners();
  }

  Color renkVer(DateTime temp) {
    Color tempColor = Colors.white;
    var asd = temp;
    DateTime tempDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime tempDate2 = DateTime(asd.year, asd.month, asd.day);
    print("Duration is");
    print(tempDate.difference(tempDate2));

    if (tempDate.difference(tempDate2) >= Duration(days: 1)) {
      tempColor = Colors.orange;
    }
    if (tempDate.difference(tempDate2) >= Duration(days: 2)) {
      tempColor = Colors.red;
    }
    
    return tempColor;
  }

  void getCantalar() {
    print("Cantalar gelmeye başladı.");
    final scoresRef = FirebaseDatabase.instance.ref("cantalar");
    scoresRef.onChildAdded.listen((event) {
      cantalarListe[event.snapshot.key] = event.snapshot.value;
      var temp = event.snapshot.value as Map<dynamic, dynamic>;
      if (temp["inAdress"] == false && temp["inCourier"] == false) {
        cantalarDepodaListe[event.snapshot.key] = event.snapshot.value;
      } else {
        cantalarKuryedeListe[event.snapshot.key] = event.snapshot.value;
      }

      if (temp["inAdress"] == true && temp["inCourier"] == false) {
        cantalarTeslimatListe[event.snapshot.key] = event.snapshot.value;
      }
      state = DataState.loading;
      state = DataState.loading;
    });
    scoresRef.onChildChanged.listen((event) {
      cantalarListe[event.snapshot.key] = event.snapshot.value;
      var temp = event.snapshot.value as Map<dynamic, dynamic>;
      if (temp["inAdress"] == false && temp["inCourier"] == false) {
        cantalarDepodaListe[event.snapshot.key] = event.snapshot.value;
      } else {
        cantalarKuryedeListe[event.snapshot.key] = event.snapshot.value;
      }

      if (temp["inAdress"] == true && temp["inCourier"] == false) {
        cantalarTeslimatListe[event.snapshot.key] = event.snapshot.value;
      }
      state = DataState.loading;
      state = DataState.loading;
    });
  }

  List<Map<String, Map<String, dynamic>>> cantalarList = [];
  // ignore: prefer_final_fields
  Map<String, dynamic> _temp = {};
  int? lastVisible;
  int page = 0;
}

final bagListProvider = ChangeNotifierProvider<BagListController>((_) => BagListController());
