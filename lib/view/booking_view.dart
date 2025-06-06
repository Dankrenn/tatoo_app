import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tatoo_app/view_model/booking_model.dart';

class BookingView extends StatelessWidget {
  const BookingView({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingModel = Provider.of<BookingModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Запись на прием'),
        centerTitle: true,
      ),
      body: bookingModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Выберите мастера',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildTattooArtistsList(bookingModel),
              const SizedBox(height: 24),
              _buildDatePicker(bookingModel, context),
              const SizedBox(height: 24),
              _buildTimePicker(bookingModel, context),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  bookingModel.saveBooking(context);
                },
                child: const Text('Сохранить запись'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTattooArtistsList(BookingModel bookingModel) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: bookingModel.tattooArtists.length,
      itemBuilder: (context, index) {
        final artist = bookingModel.tattooArtists[index];
        return ListTile(
          title: Text(artist.email),
          onTap: () {
            bookingModel.selectedArtist = artist;
          },
        );
      },
    );
  }

  Widget _buildDatePicker(BookingModel bookingModel, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Выберите дату',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (pickedDate != null) {
              bookingModel.selectedDate = pickedDate;
            }
          },
          child: Text(
            bookingModel.selectedDate != null
                ? 'Дата: ${bookingModel.selectedDate!.toLocal()}'.split(' ')[0]
                : 'Выбрать дату',
          ),
        ),
      ],
    );
  }

  Widget _buildTimePicker(BookingModel bookingModel , BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Выберите время',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () async {
            final TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (pickedTime != null) {
              bookingModel.selectedTime = pickedTime;
            }
          },
          child: Text(
            bookingModel.selectedTime != null
                ? 'Время: ${bookingModel.selectedTime!.format(context)}'
                : 'Выбрать время',
          ),
        ),
      ],
    );
  }
}
