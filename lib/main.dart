import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tatoo_app/services/hive_service.dart';
import 'package:provider/provider.dart';
import 'package:tatoo_app/services/navigation.dart';
import 'package:tatoo_app/view_model/auth_registr_model.dart';
import 'package:tatoo_app/view_model/booking_model.dart';
import 'package:tatoo_app/view_model/show_tatoo_model.dart';
import 'package:tatoo_app/view_model/theme_model.dart';
import 'view_model/profile_model.dart';

String initialRoute = NavigatorRouse.auth;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService().init();
  await initializeDateFormatting('ru_RU', null);
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyBXA1zDMHzFPpJlh84Q9YE_99uyJY-s8b0',
          appId: '1:638883314348:android:c4d76c8d3bfe5122603d09',
          messagingSenderId: '638883314348',
          projectId: 'tatooapp-9e098'));
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    initialRoute = NavigatorRouse.auth;
  } else {
    initialRoute = NavigatorRouse.auth;
  }
  runApp(const MyApp());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthModel>(
          create: (context) => AuthModel(),
        ),
        ChangeNotifierProvider<ThemeModel>(
          create: (context) => ThemeModel(),
        ),
        ChangeNotifierProvider<ShowTatooModel>(
          create: (context) => ShowTatooModel(),
        ),
        ChangeNotifierProvider<ProfileModel>(
          create: (context) => ProfileModel(),
        ),
        ChangeNotifierProvider<BookingModel>(
          create: (context) => BookingModel(),
        ),
      ],
      child: Consumer<ThemeModel>(
        builder: (context, themeModel, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            routerConfig: NavigatorApp().routerConfig,
          );
        },
      ),
    );
  }
}