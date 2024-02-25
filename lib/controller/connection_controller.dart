import 'package:PrimeTasche/controller/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:PrimeTasche/controller/base_controller.dart';

class ConnectionController extends BaseController {
  bool connected = false;

  void changeConnectionState(bool newState) {
    connected = newState;
    notifyListeners();
  }
}

final connectionProvider = ChangeNotifierProvider<ConnectionController>((_) => ConnectionController());
