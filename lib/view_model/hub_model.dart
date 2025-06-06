import 'package:flutter/material.dart';
import 'package:tatoo_app/view/profile_view.dart';
import 'package:tatoo_app/view/show_tatoo_view.dart';

class HubModel extends ChangeNotifier{
  int _currentIndex = 1;
  final List<Widget> _tabs = [
    ShowTatooView(),
    ProfileView(),
  ];

  int get currentIndex => _currentIndex;
  List<Widget> get tabs => _tabs;


  void updateCurrentIndex(int index){
    _currentIndex = index;
    notifyListeners();
  }
}