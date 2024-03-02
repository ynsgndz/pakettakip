import 'package:PrimeTasche/controller/base_controller.dart';
import 'package:PrimeTasche/main.dart';
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
bool oneShotflag = true;

class BagListController extends BaseController {
  int selectedIndex = -1;
  String selectedBagQr = "";
  String selectedKurye = "";
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

  void setSelectedBagQR(String qr) {
    selectedBagQr = qr;
    print("QR is : $qr");
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

  void selectIndex(int number) {
    selectedIndex = number;
    notifyListeners();
  }

  void depoyaAl() {
    if (cantalarListe[selectedBagQr] == null) {
      showSimpleNotification(const Text("Çanta bulunamadı."), background: Colors.blue);
      return;
    }
    if (cantalarListe[selectedBagQr]["inAdress"] == false) {
      if (cantalarListe[selectedBagQr]["inCourier"] == false) {
        showSimpleNotification(const Text("Çanta zaten depoda"), background: Colors.blue);
        return;
      }
      try {
        DatabaseReference ref = FirebaseDatabase.instance.ref("cantalar/$selectedBagQr");
        ref.update({
          "timestamp": DateTime.now().millisecondsSinceEpoch,
          "inAdress": false,
          "inCourier": false,
          "lastUser": auth.currentUser!.email,
          "location": {"lat": 0, "lon": 0},
          "packetNo": 0
        });

        selectIndex(-1);
        state = DataState.loading;
        singleShot();
        showSimpleNotification(const Text("Çanta Başarıyla depoya alındı"), background: Colors.blue);
        selectedBagQr = "";
      } on FirebaseException catch (e) {
        showSimpleNotification(Text(e.message ?? "Bilinmeyen Hata"), background: Colors.blue);
      }
    } else {
      showSimpleNotification(const Text("Adresteki çantayı depoya alamazsınız"), background: Colors.blue);
    }
  }

  void kuryeyeVer(String mail) {
    if (cantalarListe[selectedBagQr]["inAdress"] == false) {
      try {
        DatabaseReference ref = FirebaseDatabase.instance.ref("cantalar/$selectedBagQr");
        ref.update({
          "timestamp": DateTime.now().millisecondsSinceEpoch,
          "inAdress": false,
          "inCourier": true,
          "lastUser": mail,
          "location": {"lat": 0, "lon": 0},
          "packetNo": 0
        });
        state = DataState.loading;
        singleShot();
        showSimpleNotification(const Text("Çanta Başarıyla kuryeye zimmetlendi."), background: Colors.blue);
      } on FirebaseException catch (e) {
        showSimpleNotification(Text(e.message ?? "Bilinmeyen Hata"), background: Colors.blue);
      }
    } else {
      showSimpleNotification(const Text("Adresteki çantayı kuryeye zimmetleyemezsiniz."), background: Colors.blue);
    }
  }

  void build() {
    state = DataState.loading;
  }

  void unselect() {
    selectedIndex = -1;
    notifyListeners();
  }

  void kuryedeChange(bool newState) {
    kurye = newState;
    selectedIndex = -1;
    notifyListeners();
  }

  Color renkVer(DateTime temp) {
    Color tempColor = Colors.white;
    var asd = temp;
    DateTime tempDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime tempDate2 = DateTime(asd.year, asd.month, asd.day);
    print("Duration is");
    print(tempDate.difference(tempDate2));

    if (tempDate.difference(tempDate2) >= const Duration(days: 1)) {
      tempColor = Colors.orange;
    }
    if (tempDate.difference(tempDate2) >= const Duration(days: 2)) {
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
        if (temp["inCourier"] == true) {
          cantalarKuryedeListe[event.snapshot.key] = event.snapshot.value;
          cantalarDepodaListe.remove(event.snapshot.key);
        }
      }

      if (temp["inAdress"] == true && temp["inCourier"] == false) {
        cantalarTeslimatListe[event.snapshot.key] = event.snapshot.value;
      }
      state = DataState.loading;
      singleShot();
    });
    scoresRef.onChildChanged.listen((event) {
      cantalarListe[event.snapshot.key] = event.snapshot.value;
      var temp = event.snapshot.value as Map<dynamic, dynamic>;
      if (temp["inAdress"] == false && temp["inCourier"] == false) {
        cantalarDepodaListe[event.snapshot.key] = event.snapshot.value;
        cantalarKuryedeListe.remove(event.snapshot.key);
      } else {
        if (temp["inCourier"] == true) {
          cantalarKuryedeListe[event.snapshot.key] = event.snapshot.value;
          cantalarDepodaListe.remove(event.snapshot.key);
        }
      }

      if (temp["inAdress"] == true && temp["inCourier"] == false) {
        cantalarTeslimatListe[event.snapshot.key] = event.snapshot.value;
      }
      state = DataState.loading;
      singleShot();
    });
  }

  void singleShot() {
    if (oneShotflag) {
      Future.delayed(Duration(milliseconds: 200)).then((value) {
        state = DataState.data;
        oneShotflag = true;
      });
    }
    oneShotflag = false;
  }

  List<Map<String, Map<String, dynamic>>> cantalarList = [];
  // ignore: prefer_final_fields
  Map<String, dynamic> _temp = {};
  int? lastVisible;
  int page = 0;
}

final bagListProvider = ChangeNotifierProvider<BagListController>((_) => BagListController());
