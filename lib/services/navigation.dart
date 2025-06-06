import 'package:go_router/go_router.dart';
import 'package:tatoo_app/main.dart';
import 'package:tatoo_app/view/auth_view.dart';
import 'package:tatoo_app/view/booking_view.dart';
import 'package:tatoo_app/view/hub_view.dart';
import 'package:tatoo_app/view/more_details_tatoo_view.dart';
import 'package:tatoo_app/view/profile_view.dart';
import 'package:tatoo_app/view/registr_view.dart';
import 'package:tatoo_app/view/show_tatoo_view.dart';


abstract class NavigatorRouse {
  static const String auth = "/auth";
  static const String register = "/auth/register";
  static const String hub = "/hub";
  static const String profile = "/hub/profile";
  static const String showTatoo = "/hub/showTatoo";
  static const String more = "/hub/showTatoo/more";
  static const String booking = "/more/booking";
}

class NavigatorApp {
  factory NavigatorApp() {
    return _instance;
  }

  NavigatorApp._internal();

  static final NavigatorApp _instance = NavigatorApp._internal();

  static final GoRouter _router = GoRouter(
    initialLocation: initialRoute,
    routes: [
      GoRoute(path: NavigatorRouse.auth, builder: (context, state) => AuthView()),
      GoRoute(path: NavigatorRouse.register, builder: (context, state) => RegistrView()),
      GoRoute(path: NavigatorRouse.hub, builder: (context, state) => HubView()),
      GoRoute(path: NavigatorRouse.profile, builder: (context, state) => ProfileView()),
      GoRoute(path: NavigatorRouse.showTatoo, builder: (context, state) => ShowTatooView()),
      GoRoute(path: NavigatorRouse.more, builder: (context, state) => MoreDetailsTatooView()),
      GoRoute(path: NavigatorRouse.booking, builder: (context, state) => BookingView()),
    ],
  );
  GoRouter get routerConfig => _router;
}