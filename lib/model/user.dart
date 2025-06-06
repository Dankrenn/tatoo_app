import 'package:tatoo_app/model/record.dart';
import 'package:tatoo_app/model/tatoo.dart';

class UserApp {
  final String id;
  final String email;
  final List<Tattoo> favoriteTattoos;
  final List<RecordApp> records;
  final String role;

  UserApp({
    required this.id,
    required this.email,
    required this.favoriteTattoos,
    required this.records,
    required this.role,
  });
}
