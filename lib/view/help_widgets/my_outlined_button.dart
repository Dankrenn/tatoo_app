import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tatoo_app/view_model/theme_model.dart';

class MyOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;
  final bool isFullWidth;

   MyOutlinedButton({
    super.key,
    required this.text,
    required this.callback,
     required this.isFullWidth,
  });

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ThemeModel>(context);
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: OutlinedButton(
        onPressed: callback,
        style: OutlinedButton.styleFrom(
      side: BorderSide(color: model.isDarkMode ? Colors.white : Colors.black ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text, // Используем переданный текст
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}