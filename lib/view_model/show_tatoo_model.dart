import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tatoo_app/model/tatoo.dart';
import 'package:tatoo_app/services/navigation.dart';
import 'package:tatoo_app/services/superbase_services.dart';

class ShowTatooModel extends ChangeNotifier {
  SuperBaseServices _superBaseServices = SuperBaseServices();
  List<Tattoo> _tattoos = [];
  List<Tattoo> _filteredTattoos = [];
  double _minPrice = 3000;
  double _maxPrice = 250000;
  String _nameQuery = '';
  late Tattoo _selectTattoo;
  bool isFavorite = false;

  ShowTatooModel(){
    _load();
  }

  void _load(){
    _tattoos = _superBaseServices.getAllTattoos() as List<Tattoo>;
    _filteredTattoos = _tattoos;
  }

  List<Tattoo> get tattoos => _filteredTattoos.isNotEmpty ? _filteredTattoos : _tattoos;
  List<Tattoo> get filteredTattoos => _filteredTattoos;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  Tattoo get selectTattoo => _selectTattoo;

  void setNameQuery(String query) {
    _nameQuery = query;
    filterTattoos();
  }
  void setPriceRange(double minPrice, double maxPrice) {
    _minPrice = minPrice;
    _maxPrice = maxPrice;
    filterTattoos();
  }
  void filterTattoos() {
    if (_nameQuery.isEmpty && _minPrice == 0 && _maxPrice == 500) {
      _filteredTattoos = List.from(_tattoos);
    } else {
      _filteredTattoos = _tattoos.where((tattoo) {
        final matchesName =
        tattoo.name.toLowerCase().contains(_nameQuery.toLowerCase());
        final matchesPrice =
            tattoo.price >= _minPrice && tattoo.price <= _maxPrice;
        return matchesName && matchesPrice;
      }).toList();
    }
    notifyListeners();
  }





  void toggleFavorite() {
  }


  void goBooking(BuildContext context) {

  }

  void goMore(BuildContext context, Tattoo tattoo) {
    _selectTattoo = tattoo;
    context.push(NavigatorRouse.more);
  }
}
