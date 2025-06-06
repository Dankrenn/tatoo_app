import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tatoo_app/view_model/show_tatoo_model.dart';
import 'package:tatoo_app/view/help_widgets/tattoo_card.dart';

class ShowTatooView extends StatelessWidget {
  const ShowTatooView({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ShowTatooModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Галерея услуг'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchField(model),
          _buildPriceSlider(model),
          _buildTattoosGrid(model, context),
        ],
      ),
    );
  }

  Widget _buildSearchField(ShowTatooModel model) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Поиск по названию',
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => model.setNameQuery(''),
          ),
        ),
        onChanged: model.setNameQuery,
      ),
    );
  }

  Widget _buildPriceSlider(ShowTatooModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          RangeSlider(
            values: RangeValues(model.minPrice, model.maxPrice),
            min: 500,
            max: 10000,
            divisions: 95,
            labels: RangeLabels(
              '${model.minPrice.toInt()} ₽',
              '${model.maxPrice.toInt()} ₽',
            ),
            onChanged: (values) => model.setPriceRange(values.start, values.end),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('500 ₽'),
              Text('10 000 ₽'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTattoosGrid(ShowTatooModel model, BuildContext context) {
    if (model.isLoading) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }

    if (model.tattoos.isEmpty) {
      return const Expanded(
        child: Center(child: Text('Татуировки не найдены')),
      );
    }

    return Expanded(
      child: GridView.builder(
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
            isFavorite: model.isFavorite(tattoo),
            onTap: () => model.navigateToDetails(context, tattoo),
            onFavoriteToggle: () => model.toggleFavorite(tattoo, context),
          );
        },
      ),
    );
  }
}