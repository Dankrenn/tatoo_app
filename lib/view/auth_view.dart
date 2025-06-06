import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tatoo_app/view/help_widgets/my_button.dart';
import 'package:tatoo_app/view/help_widgets/my_outlined_button.dart';
import 'package:tatoo_app/view/help_widgets/my_text_field.dart';
import 'package:tatoo_app/view_model/auth_registr_model.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AuthModel>(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 24),
                const Text(
                  'Добро пожаловать',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Войдите в свой аккаунт',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 32),
                MyTextField(
                  hintText: 'Email',
                  isPassword: false,
                  onChanged: (value) => model.setEmail(value),
                ),
                const SizedBox(height: 16),
                MyTextField(
                  hintText: 'Пароль',
                  isPassword: true,
                  onChanged: (value) => model.setPassword(value),
                ),
                const SizedBox(height: 24),
                MyButton(
                  text: 'Войти',
                  callback: () => model.authUser(context),
                  isFullWidth: true,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('ИЛИ'),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),
                MyOutlinedButton(
                  text: 'Создать аккаунт',
                  callback: () => model.goRegistr(context),
                  isFullWidth: true,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
