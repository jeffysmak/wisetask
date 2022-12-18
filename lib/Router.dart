import 'package:flutter/material.dart';
import 'package:wisofttask/dashboard.dart';
import 'package:wisofttask/error_screen.dart';
import 'package:wisofttask/scanerio1/Home.dart';
import 'package:wisofttask/scanerio1/Home2.dart';
import 'package:wisofttask/scanerio1/OrderDetailed.dart';
import 'package:wisofttask/scanerio1/Orders.dart';
import 'package:wisofttask/splash_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case SplashScreen.Route:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case DashboardScreen.Route:
        return MaterialPageRoute(builder: (_) => DashboardScreen());
      case HomeScreen.Route:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case OrdersList.Route:
        return MaterialPageRoute(builder: (_) => OrdersList());
      case Home2.Route:
        return MaterialPageRoute(builder: (_) => Home2());
      case OrderDetailed.Route:
        return MaterialPageRoute(builder: (_) => OrderDetailed((args as Map)['order']));
      case MapScreen.Route:
        return MaterialPageRoute(builder: (_) => MapScreen((args as Map)['order']));
      default:
        return MaterialPageRoute(builder: (_) => ErrorScreen());
    }
  }
}
