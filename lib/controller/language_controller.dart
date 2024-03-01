import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:PrimeTasche/controller/base_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riverpod_context/riverpod_context.dart';

class LanguageController extends BaseController {
  Widget languageWidget = Consumer(
    builder: (context, ref, child) {
      bool english = ref.watch(languageProvider.select((value) => value.isEnglish));
      if (english) {
        return GestureDetector(
          onTap: () {
            context.read(languageProvider).german();
          },
          child: Container(
            padding: EdgeInsets.all(8),
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
          },
          child: Container(
            padding: EdgeInsets.all(8),
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

  bool isEnglish = true;

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
