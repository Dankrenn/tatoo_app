import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tatoo_app/model/record.dart';
import 'package:tatoo_app/model/tatoo.dart';
import 'package:tatoo_app/model/user.dart';
import 'package:tatoo_app/services/navigation.dart';
import 'package:tatoo_app/services/superbase_services.dart';
import 'package:tatoo_app/services/validator.dart';

class AuthModel extends ChangeNotifier {
  String _email = '';
  String _password = '';
  String _configPassword = '';
  bool _showPassword = false;
  SuperBaseServices superBaseServices = SuperBaseServices();

  String get email => _email;

  String get password => _password;

  String get configPassword => _configPassword;

  bool get showPassword => _showPassword;

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    _configPassword = value;
    notifyListeners();
  }

  void setShowPassword() {
    _showPassword = !_showPassword;
    notifyListeners();
  }

  void _clearInfo() {
    _email = '';
    _password = '';
    _configPassword = '';
    _showPassword = false;
  }

  void goAuth(BuildContext context) {
    _clearInfo();
    context.push(NavigatorRouse.auth);
  }

  void goRegistr(BuildContext context) {
    _clearInfo();
    context.push(NavigatorRouse.register);
  }

  void _goHub(BuildContext context) {
    _clearInfo();
    context.push(NavigatorRouse.hub);
  }

  void authUser(BuildContext context) async {
    String? emailError = Validator.validateEmail(_email);
    String? passwordError = Validator.validatePassword(_password);

    if (emailError != null) {
      Validator.showError(context, emailError);
      return;
    }

    if (passwordError != null) {
      Validator.showError(context, passwordError);
      return;
    }

    try {
      User? user = await superBaseServices.login(_email, _password);
      if (user != null) {
        _goHub(context);
      }
    } catch (e) {
      Validator.showError(context, e.toString());
    }
  }

  void registerUser(BuildContext context) async {
    String? emailError = Validator.validateEmail(_email);
    String? passwordError = Validator.validatePassword(_password);

    if (_password != _configPassword) {
      Validator.showError(context, 'Пароли не совпадают');
      return;
    }

    if (emailError != null) {
      Validator.showError(context, emailError);
      return;
    }

    if (passwordError != null) {
      Validator.showError(context, passwordError);
      return;
    }

    try {
      User? user = await superBaseServices.register(_email, _password);
      if (user != null) {
        UserApp newUser = UserApp(
          id: user.uid,
          email: _email,
          favoriteTattoos: [],
          records: [],
          role: 'client',
        );

        await superBaseServices.saveUserData(newUser);
        goAuth(context);
      }
    } catch (e) {
      Validator.showError(context, e.toString());
    }
  }
}
