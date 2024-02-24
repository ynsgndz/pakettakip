import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pakettakip/controller/base_controller.dart';
import 'package:pakettakip/controller/input_controller.dart';
import 'package:pakettakip/main.dart';
import 'package:pakettakip/route_provider.dart';

Map<dynamic, dynamic> kuryeListe = {};

class KuryeController extends BaseController {
  Map<String, dynamic> _temp = {};
  int? lastVisible;
  int page = 0;
  Future<UserCredential?> register(String email, String password) async {
    String id = "";
    UserCredential? userCredential;
    FirebaseApp app = await Firebase.initializeApp(name: 'Secondary', options: Firebase.app().options);
    try {
      UserCredential userCredential =
          await FirebaseAuth.instanceFor(app: app).createUserWithEmailAndPassword(email: email, password: password);
      id = userCredential.user!.uid.toString();
      if (userCredential.user != null) {
        userCredential.user!.updateDisplayName(container.read(inputProvider).kuryeEkleism.text);
      }
    } on FirebaseAuthException catch (e) {
      showSimpleNotification(Text(e.message ?? "Bilinmeyen Hata"), background: Colors.blue);
    }
    if (id != "") {
      DatabaseReference ref = FirebaseDatabase.instance.ref("users/${id}");
      try {
        await ref.set({
          "mail": container.read(inputProvider).kuryeEkleMail.text,
          "pass": container.read(inputProvider).kuryeEklepass.text,
          "name": container.read(inputProvider).kuryeEkleism.text,
        });

        container.read(routeProvider).pop();
      } on FirebaseException catch (a) {
        showSimpleNotification(Text(a.message ?? "Bilinmeyen Hata"), background: Colors.blue);
      }
    }
    return userCredential;
  }

  Map<dynamic, dynamic> kuryeVer() {
    return kuryeListe;
  }

  void getKurye() {
    final scoresRef = FirebaseDatabase.instance.ref("users");
    scoresRef.onChildAdded.listen((event) {
      kuryeListe[event.snapshot.key] = event.snapshot.value;
      state = DataState.loading;
      state = DataState.loading;
    });
  }
}

final kuryeListProvider = ChangeNotifierProvider<KuryeController>((_) => KuryeController());
