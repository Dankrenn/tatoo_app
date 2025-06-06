import 'package:flutter/material.dart';

class Validator {

  static void showError(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  static String? validateEmail(String email) {
    if (email.isEmpty) {
      return "Email не может быть пустым";
    }

    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegExp.hasMatch(email)) {
      return "Некорректный формат email";
    }
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return "Пароль не может быть пустым";
    }
    if (password.length < 8) {
      return "Пароль должен содержать не менее 8 символов";
    }
    // Password regex pattern: at least one digit, one letter, and one special character
    final passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]+$');
    if (!passwordRegExp.hasMatch(password)) {
      return "Пароль должен содержать буквы, цифры и специальные символы";
    }
    return null;
  }
}
