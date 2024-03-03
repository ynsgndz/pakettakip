import 'package:PrimeTasche/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:PrimeTasche/controller/base_controller.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:riverpod_context/riverpod_context.dart';

class LanguageController extends BaseController {
  bool isEnglish = true;
  final storage = GetStorage();
  Widget languageWidget = Consumer(
    builder: (context, ref, child) {
      bool english = ref.watch(languageProvider.select((value) => value.isEnglish));
      if (english) {
        return GestureDetector(
          onTap: () {
            context.read(languageProvider).german();
            container.read(languageProvider).storage.write("lang", false);
            showSimpleNotification(const Text("Bitte starten Sie die App neu, damit Ihre Spracheinstellungen wirksam werden"),
                background: Colors.blue);
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)),
            child: Center(
              child: Text(
                "EN",
                style: GoogleFonts.openSans(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
        );
      } else {
        return GestureDetector(
          onTap: () {
            context.read(languageProvider).english();
            container.read(languageProvider).storage.write("lang", true);
            showSimpleNotification(const Text("Please restart the app for your language settings to take effect"),
                background: Colors.blue);
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)),
            child: Center(
              child: Text(
                "DE",
                style: GoogleFonts.openSans(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
        );
      }
    },
  );

  void english() {
    isEnglish = true;
    notifyListeners();
  }

  void german() {
    isEnglish = false;
    notifyListeners();
  }
}

final languageProvider = ChangeNotifierProvider<LanguageController>((_) => LanguageController());
