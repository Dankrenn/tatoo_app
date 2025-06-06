import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tatoo_app/model/tatoo.dart';
import 'package:tatoo_app/view_model/show_tatoo_model.dart';

class TattooCard extends StatelessWidget {
  final Tattoo tattoo;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final bool isFavorite;

  const TattooCard({
    super.key,
    required this.tattoo,
    required this.onTap,
    required this.onFavoriteToggle,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 200,
            maxHeight: 300,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Добавляем это
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded( // Оборачиваем изображение в Expanded
                child: Stack(
                  children: [
                    Image.network(
                      tattoo.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.white,
                        ),
                        onPressed: onFavoriteToggle,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // Добавляем это
                  children: [
                    Text(
                      tattoo.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text('Автор: ${tattoo.artistFullName}'),
                    Text('Цена: ${tattoo.price.toStringAsFixed(2)} ₽'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
