import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tatoo_app/model/record.dart';
import 'package:tatoo_app/model/tatoo.dart';
import 'package:tatoo_app/model/user.dart';
import 'package:tatoo_app/services/navigation.dart';
import 'package:tatoo_app/services/superbase_services.dart';
import 'package:tatoo_app/view_model/profile_model.dart';

class BookingModel extends ChangeNotifier {
  final SuperBaseServices _superBaseServices = SuperBaseServices();
  List<UserApp> tattooArtists = [];
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  UserApp? selectedArtist;
  bool isLoading = false;

  BookingModel() {
    _loadTattooArtists();
  }

  Future<void> _loadTattooArtists() async {
    try {
      isLoading = true;
      notifyListeners();

      // Загрузка списка мастеров
      tattooArtists = await _superBaseServices.getTattooArtists();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error loading tattoo artists: $e');
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveBooking(BuildContext context) async {
    if (selectedArtist == null || selectedDate == null || selectedTime == null) {
      throw Exception('Необходимо выбрать мастера, дату и время');
    }

    DateTime bookingDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    RecordApp newRecord = RecordApp(
      dateTime: bookingDateTime,
      status: 'ожидание',
      tattooArtist: selectedArtist!,
    );

    try {
      isLoading = true;
      notifyListeners();

      // Сохранение записи в базе данных
      User? user =  _superBaseServices.getCurrentUser();
      await _superBaseServices.saveBooking(newRecord);
      isLoading = false;
      notifyListeners();
      ProfileModel profileModel = Provider.of<ProfileModel>(context, listen: false);
      await profileModel.refreshUserData();
      context.go(NavigatorRouse.hub);
    } catch (e) {
      print('Error saving booking: $e');
      isLoading = false;
      notifyListeners();
      throw Exception('Ошибка при сохранении записи');
    }
  }
}
