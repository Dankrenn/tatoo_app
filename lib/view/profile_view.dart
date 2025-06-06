import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tatoo_app/model/record.dart';
import 'package:tatoo_app/model/tatoo.dart';
import 'package:tatoo_app/model/user.dart';
import 'package:tatoo_app/view_model/profile_model.dart';
import 'package:tatoo_app/view_model/theme_model.dart';
import 'package:tatoo_app/view/help_widgets/tattoo_card.dart';
import 'package:intl/intl.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Профиль'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              final themeModel =
                  Provider.of<ThemeModel>(context, listen: false);
              themeModel.updateTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              final model = Provider.of<ProfileModel>(context, listen: false);
              model.logout(context);
            },
          ),
        ],
      ),
      body: Consumer<ProfileModel>(
        builder: (context, model, child) {
          if (model.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (model.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  model.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (model.user == null) {
            return const Center(
                child: Text('Данные пользователя не загружены'));
          }

          return _buildProfileContent(context, model.user!);
        },
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, UserApp user) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserInfoWidget(email: user.email),
            const SizedBox(height: 24),
            _buildBookingSection(user.records),
            const SizedBox(height: 24),
            _buildFavoritesSection(user.favoriteTattoos),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingSection(List<RecordApp> records) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'История записей',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        records.isEmpty
            ? _buildEmptyState(
                icon: Icons.calendar_today,
                message: 'У вас пока нет записей',
              )
            : BookingHistoryWidget(records: records),
      ],
    );
  }

  Widget _buildFavoritesSection(List<Tattoo> favoriteTattoos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Понравившиеся услуги',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        favoriteTattoos.isEmpty
            ? _buildEmptyState(
                icon: Icons.favorite_border,
                message: 'Вы пока ничего не добавили в избранное',
              )
            : FavoriteTattoosWidget(favoriteTattoos: favoriteTattoos),
      ],
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Column(
          children: [
            Icon(icon, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserInfoWidget extends StatelessWidget {
  final String email;

  const UserInfoWidget({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 24,
              child: Icon(Icons.person),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    email,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Клиент',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingHistoryWidget extends StatelessWidget {
  final List<RecordApp> records;

  const BookingHistoryWidget({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: records.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return BookingRecordCard(record: records[index]);
      },
    );
  }
}

class BookingRecordCard extends StatelessWidget {
  final RecordApp record;
  final DateFormat dateFormat = DateFormat('dd MMMM yyyy', 'ru_RU');
  final DateFormat timeFormat = DateFormat('HH:mm');

  BookingRecordCard({super.key, required this.record});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'подтверждено':
        return Colors.green;
      case 'отменено':
        return Colors.red;
      case 'ожидание':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateFormat.format(record.dateTime),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  backgroundColor:
                      _getStatusColor(record.status).withOpacity(0.1),
                  label: Text(
                    record.status,
                    style: TextStyle(
                      color: _getStatusColor(record.status),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Время: ${timeFormat.format(record.dateTime)}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 20,
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Мастер: ${record.tattooArtist.email}',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteTattoosWidget extends StatelessWidget {
  final List<Tattoo> favoriteTattoos;

  const FavoriteTattoosWidget({super.key, required this.favoriteTattoos});

  @override
  Widget build(BuildContext context) {
    final profileModel = Provider.of<ProfileModel>(context);

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.7,
      ),
      itemCount: favoriteTattoos.length,
      itemBuilder: (context, index) {
        final tattoo = favoriteTattoos[index];
        return TattooCard(
          tattoo: tattoo,
          onTap: () => profileModel.goMore(context, tattoo),
          onFavoriteToggle: () => profileModel.removeFromFavorites(tattoo),
          isFavorite: true,
        );
      },
    );
  }
}
