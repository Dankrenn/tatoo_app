import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tatoo_app/view/help_widgets/tattoo_card.dart';
import 'package:tatoo_app/view_model/show_tatoo_model.dart';

class ShowTatooView extends StatelessWidget {
  const ShowTatooView({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ShowTatooModel>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Галерея'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Поиск по названию',
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                model.setNameQuery(query);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RangeSlider(
              values: RangeValues(model.minPrice, model.maxPrice),
              min: 500,
              max: 7000,
              divisions: 50,
              labels: RangeLabels(
                model.minPrice.toStringAsFixed(0),
                model.maxPrice.toStringAsFixed(0),
              ),
              onChanged: (RangeValues values) {
                model.setPriceRange(values.start, values.end);
              },
            ),
          ),
          Expanded(
            child: model.filteredTattoos.isEmpty
                ? const Center(
              child: Text(
                'Таких услуг нет',
                style: TextStyle(fontSize: 18),
              ),
            )
                : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.7,
              ),
              itemCount: model.tattoos.length,
              itemBuilder: (context, index) {
                final tattoo = model.tattoos[index];
                return TattooCard(
                  tattoo: tattoo,
                  onTap: () => model.goMore(context, model.tattoos[index]),
                  onFavoriteToggle: () => {},
                  isFavorite: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

