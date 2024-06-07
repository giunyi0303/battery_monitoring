import 'package:flutter/cupertino.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel._();
  static final HomeViewModel _instance = HomeViewModel._();

  factory HomeViewModel() {
    return _instance;
  }
}
