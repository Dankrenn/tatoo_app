import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tatoo_app/model/record.dart';
import 'package:tatoo_app/model/tatoo.dart';
import 'package:tatoo_app/model/user.dart';
import 'package:tatoo_app/services/navigation.dart';
import 'package:tatoo_app/services/superbase_services.dart';
import 'package:tatoo_app/view_model/show_tatoo_model.dart';

class ProfileModel extends ChangeNotifier {
  UserApp? user;
  bool isLoading = false;
  String? errorMessage;
  final SuperBaseServices _superBaseServices = SuperBaseServices();

  ProfileModel() {
    _loadUserData();
  }

  // Загрузка данных пользователя
  Future<void> _loadUserData() async {
    try {
      _setLoading(true);

      final currentUser = _superBaseServices.getCurrentUser();
      if (currentUser == null) {
        throw Exception('Пользователь не авторизован');
      }

      final userData = await _superBaseServices.getUserData(currentUser.uid);
      if (userData == null) {
        throw Exception('Данные пользователя не найдены');
      }

      user = _parseUserData(currentUser, userData);
      errorMessage = null;
    } catch (e) {
      errorMessage = 'Ошибка загрузки данных: ${e.toString()}';
      print(errorMessage);
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  UserApp _parseUserData(User currentUser, Map<String, dynamic> userData) {
    List<dynamic>? favoriteTattoosData = userData['favoriteTattoos'] is List
        ? userData['favoriteTattoos']
        : null;

    List<dynamic>? recordsData = userData['records'] is List
        ? userData['records']
        : null;

    return UserApp(
      email: userData['email'] ?? currentUser.email ?? '',
      favoriteTattoos: _parseTattoos(favoriteTattoosData),
      records: _parseRecords(recordsData),
      role: userData['role'] ?? 'client',
      id: currentUser.uid,
    );
  }

  List<Tattoo> _parseTattoos(List<dynamic>? tattoosData) {
    if (tattoosData == null) return [];

    return tattoosData.map((tattooData) => Tattoo(
      id: tattooData['id'] ?? '',
      name: tattooData['name'] ?? '',
      imageUrl: tattooData['imageUrl'] ?? '',
      artistFullName: tattooData['artistFullName'] ?? '',
      price: (tattooData['price'] ?? 0).toDouble(),
    )).toList();
  }

  List<RecordApp> _parseRecords(List<dynamic>? recordsData) {
    if (recordsData == null) return [];

    return recordsData.map((recordData) {
      final artistData = recordData['tattooArtist'] ?? {};

      return RecordApp(
        dateTime: DateTime.parse(recordData['dateTime']),
        status: 'отменено',
        tattooArtist: UserApp(
          email: artistData['email'] ?? '',
          favoriteTattoos: [],
          records: [],
          role: artistData['role'] ?? 'artist',
          id: '1',
        ),
      );
    }).toList();
  }

  // Обновление состояния загрузки
  void _setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  // обновление данных данных
  Future<void> refreshUserData() async {
    await _loadUserData();
  }

  // Удаление из избранного
  Future<void> removeFromFavorites(Tattoo tattoo) async {
    try {
      User? currentUser = _superBaseServices.getCurrentUser();
      if (currentUser == null) {
        throw Exception('Пользователь не авторизован');
      }

      if (user != null) {
        user!.favoriteTattoos.removeWhere((t) => t.id == tattoo.id);
        await _superBaseServices.saveUserData(user!);
        await refreshUserData(); // Refresh user data to reflect changes
      }
    } catch (e) {
      errorMessage = 'Ошибка при удалении из избранного: ${e.toString()}';
      print(errorMessage);
    }
  }

  // Выход из системы
  Future<void> logout(BuildContext context) async {
    try {
      _setLoading(true);
      await _superBaseServices.logout();
      context.go(NavigatorRouse.auth);
    } catch (e) {
      errorMessage = 'Ошибка при выходе: ${e.toString()}';
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  void goMore(BuildContext context, Tattoo tattoo) {
    final model = Provider.of<ShowTatooModel>(context, listen: false);
    //model.setSelectTattoo(tattoo);
    context.push(NavigatorRouse.more, extra: tattoo);
  }


  void goBooking(BuildContext context) {
    context.push(NavigatorRouse.booking);
  }
}
