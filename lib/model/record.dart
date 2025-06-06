import 'package:tatoo_app/model/user.dart';

class RecordApp {
  final DateTime dateTime;
  final String status;
  final UserApp tattooArtist;

  RecordApp({
    required this.dateTime,
    required this.status,
    required this.tattooArtist,
  });
}
