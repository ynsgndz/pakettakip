import 'package:flutter/material.dart';

enum DataState { initial, loading, data, error, empty }

abstract class BaseController<T> extends ChangeNotifier {
  T? data;

  DataState _state = DataState.initial;

  DataState get state => _state;

  set state(DataState value) {
    _state = value;
    notifyListeners();
  }
/*
  Future<void> load({bool slient = false}) async {}
  Future<void> loadMore() async {}*/
}
