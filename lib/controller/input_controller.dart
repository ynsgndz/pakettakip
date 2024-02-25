import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:PrimeTasche/controller/base_controller.dart';

class InputController extends BaseController {
  var mail = TextEditingController();
  var pass = TextEditingController();
  var qr = TextEditingController();
  var cantaPass = TextEditingController();

  var kuryeEkleMail = TextEditingController();
  var kuryeEkleism = TextEditingController();
  var kuryeEklepass = TextEditingController();

  var paketNo = TextEditingController();
}

final inputProvider = ChangeNotifierProvider<InputController>((_) => InputController());
