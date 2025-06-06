import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tatoo_app/model/tatoo.dart';
import 'package:tatoo_app/services/navigation.dart';
import 'package:tatoo_app/services/superbase_services.dart';
import 'package:tatoo_app/view_model/profile_model.dart';

class ShowTatooModel extends ChangeNotifier {
  final SuperBaseServices _superBaseServices = SuperBaseServices();
  List<Tattoo> _tattoos = [];
  List<Tattoo> _filteredTattoos = [];
  List<Tattoo> _favoriteTattoos = [];
  double _minPrice = 500;
  double _maxPrice = 10000;
  String _nameQuery = '';
  late Tattoo _selectTattoo;
  bool _isLoading = true;
  Tattoo get selectTattoo => _selectTattoo;
  ShowTatooModel() {
    _init();
  }

  Future<void> _init() async {
    await _loadTattoos();
    await _loadFavorites();
  }

  Future<void> _loadTattoos() async {
    try {
      _isLoading = true;
      notifyListeners();

      _tattoos = await _superBaseServices.getAllTattoos();
      _filteredTattoos = _tattoos;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Error loading tattoos: $e');
    }
  }

  Future<void> _loadFavorites() async {
    try {
      final user = _superBaseServices.getCurrentUser();
      if (user != null) {
        final userData = await _superBaseServices.getUserData(user.uid);
        if (userData != null && userData['favoriteTattoos'] != null) {
          _favoriteTattoos = (userData['favoriteTattoos'] as List)
              .map((item) => Tattoo.fromMap(item))
              .toList();
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  List<Tattoo> get tattoos => _filteredTattoos;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  Tattoo get selectedTattoo => _selectTattoo;
  bool get isLoading => _isLoading;

  void setNameQuery(String query) {
    _nameQuery = query;
    _applyFilters();
  }

  void setPriceRange(double min, double max) {
    _minPrice = min;
    _maxPrice = max;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredTattoos = _tattoos.where((tattoo) {
      final matchesName = _nameQuery.isEmpty ||
          tattoo.name.toLowerCase().contains(_nameQuery.toLowerCase());
      final matchesPrice = tattoo.price >= _minPrice && tattoo.price <= _maxPrice;
      return matchesName && matchesPrice;
    }).toList();
    notifyListeners();
  }

  bool isFavorite(Tattoo tattoo) {
    return _favoriteTattoos.any((fav) => fav.id == tattoo.id);
  }

  Future<void> toggleFavorite(Tattoo tattoo, BuildContext context) async {
    try {
      if (isFavorite(tattoo)) {
        await _superBaseServices.removeFromFavorites(tattoo);
        _favoriteTattoos.removeWhere((t) => t.id == tattoo.id);
      } else {
        await _superBaseServices.addToFavorites(tattoo);
        _favoriteTattoos.add(tattoo);
      }
      notifyListeners();

      // Обновляем данные в ProfileModel
      final profileModel = Provider.of<ProfileModel>(context, listen: false);
      await profileModel.refreshUserData();
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
      rethrow;
    }
  }

  void navigateToDetails(BuildContext context, Tattoo tattoo) {
    _selectTattoo = tattoo;
    context.push(NavigatorRouse.more);
  }

  void navigateToBooking(BuildContext context, Tattoo tattoo) {
    _selectTattoo = tattoo;
    context.push(NavigatorRouse.booking);
  }

  void setSelectedTattoo(Tattoo tattoo) {
    _selectTattoo = tattoo;
    notifyListeners();
  }
}