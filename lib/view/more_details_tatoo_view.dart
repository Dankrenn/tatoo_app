import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tatoo_app/view/help_widgets/my_outlined_button.dart';
import 'package:tatoo_app/view_model/show_tatoo_model.dart';

class MoreDetailsTatooView extends StatelessWidget {
  const MoreDetailsTatooView({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ShowTatooModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('О услуге'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network(
                    model.selectTattoo.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 300,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                model.selectTattoo.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Автор: ${model.selectTattoo.artistFullName}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Цена: ${model.selectTattoo.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 24),
              MyOutlinedButton(
                text: 'Хочу записаться',
                callback: () => model.goBooking(context),
                isFullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
