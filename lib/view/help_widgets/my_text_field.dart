import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tatoo_app/view_model/auth_registr_model.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final ValueChanged<String> onChanged;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.isPassword,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AuthModel>(context);

    return TextField(
      obscureText: isPassword ? !model.showPassword : false,
      style: const TextStyle(
        fontSize: 16,
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1.5),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        suffixIcon: isPassword
            ? IconButton(
          onPressed: model.setShowPassword,
          icon: Icon(
            model.showPassword ? Icons.visibility_off : Icons.visibility,
          ),
        )
            : null,
      ),
      onChanged: onChanged,
    );
  }
}
