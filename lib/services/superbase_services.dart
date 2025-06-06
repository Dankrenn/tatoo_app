import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tatoo_app/model/record.dart';
import 'package:tatoo_app/model/tatoo.dart';
import 'package:tatoo_app/model/user.dart';

class SuperBaseServices extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Метод для получения текущего пользователя
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Регистрация пользователя
  Future<User?> register(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      throw Exception("Пользователь с таким email уже существует");
    } catch (e) {
      try {
        UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        // await sendVerificationEmail();
        return result.user;
      } catch (e) {
        throw Exception("Ошибка при регистрации пользователя: ${e.toString()}");
      }
    }
  }

  // Вход в систему
  Future<User?> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // if (!result.user!.emailVerified) {
      //   throw Exception("Пожалуйста, подтвердите свой email");
      // }
      return result.user;
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          throw Exception("Пользователя не существует");
        } else if (e.code == 'wrong-password') {
          throw Exception("Неверный пароль");
        }
      }
      throw Exception("Ошибка при входе пользователя: ${e.toString()}");
    }
  }

  // Выход из системы
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception("Ошибка при выходе из аккаунта: ${e.toString()}");
    }
  }

  // Метод для сохранения данных пользователя
  Future<void> saveUserData(UserApp userApp) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        List<Map<String, dynamic>> favoriteTattoosList = userApp.favoriteTattoos
            .map((tattoo) => _convertTattooToMap(tattoo))
            .toList();

        List<Map<String, dynamic>> recordsList = userApp.records
            .map((record) => _convertRecordToMap(record))
            .toList();

        await _firestore.collection('users').doc(user.uid).set({
          'email': userApp.email,
          'role': userApp.role,
          'favoriteTattoos': favoriteTattoosList,
          'records': recordsList,
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print('Error saving user data: $e');
      throw e;
    }
  }

  // Вспомогательный метод для конвертации тату в Map
  Map<String, dynamic> _convertTattooToMap(Tattoo tattoo) {
    return {
      'id': tattoo.id,
      'name': tattoo.name,
      'imageUrl': tattoo.imageUrl,
      'artistFullName': tattoo.artistFullName,
      'price': tattoo.price,
    };
  }

  // Вспомогательный метод для конвертации записи в Map
  Map<String, dynamic> _convertRecordToMap(RecordApp record) {
    return {
      'dateTime': record.dateTime.toIso8601String(),
      'status': record.status,
      'tattooArtist': {
        'email': record.tattooArtist.email,
        'role': record.tattooArtist.role,
        // Можно добавить другие поля пользователя при необходимости
      },
    };
  }

  //метод для получение информации о пользователе
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      DocumentSnapshot doc =
      await _firestore.collection('users').doc(userId).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      debugPrint('Error getting user data: $e');
      throw Exception('Не удалось получить данные пользователя');
    }
  }

  Future<List<Tattoo>> getAllTattoos() async {
    try {
      QuerySnapshot querySnapshot =
      await _firestore.collection('tattoos').get();
      return querySnapshot.docs.map((doc) {
        return Tattoo(
          id: doc.id,
          name: doc['name'],
          imageUrl: doc['imageUrl'],
          artistFullName: doc['artistFullName'],
          price: doc['price'].toDouble(),
        );
      }).toList();
    } catch (e) {
      print('Error fetching tattoos: $e');
      throw Exception('Failed to fetch tattoos');
    }
  }

  Future<void> addTattoo(Tattoo tattoo) async {
    try {
      await _firestore.collection('tattoos').doc(tattoo.id).set({
        'name': tattoo.name,
        'imageUrl': tattoo.imageUrl,
        'artistFullName': tattoo.artistFullName,
        'price': tattoo.price,
      });
    } catch (e) {
      print('Error adding tattoo: $e');
      throw Exception('Failed to add tattoo');
    }
  }

  Future<void> saveBooking(RecordApp record) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('Пользователь не авторизован');
      }

      // Сохранение записи в базе данных
      await _firestore.collection('users').doc(currentUser.uid).update({
        'records': FieldValue.arrayUnion([
          _convertRecordToMap(record),
        ]),
      });
    } catch (e) {
      print('Error saving booking: $e');
      throw Exception('Ошибка при сохранении записи');
    }
  }

  Future<List<UserApp>> getTattooArtists() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'artist')
          .get();

      return querySnapshot.docs.map((doc) {
        return UserApp(
          id: doc.id,
          email: doc['email'] ?? '',
          favoriteTattoos: [],
          records: [],
          role: doc['role'] ?? 'artist',
        );
      }).toList();
    } catch (e) {
      print('Error fetching tattoo artists: $e');
      throw Exception('Failed to fetch tattoo artists');
    }
  }

  Future<void> addToFavorites(Tattoo tattoo) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'favoriteTattoos': FieldValue.arrayUnion([
            _convertTattooToMap(tattoo),
          ]),
        });
      }
    } catch (e) {
      print('Error adding to favorites: $e');
      throw Exception('Ошибка при добавлении в избранное');
    }
  }

  Future<void> removeFromFavorites(Tattoo tattoo) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'favoriteTattoos': FieldValue.arrayRemove([
            _convertTattooToMap(tattoo),
          ]),
        });
      }
    } catch (e) {
      print('Error removing from favorites: $e');
      throw Exception('Ошибка при удалении из избранного');
    }
  }
}










