import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wisofttask/Router.dart';
import 'package:wisofttask/controllers/AppController.dart';
import 'package:wisofttask/controllers/LocationHelperProvider.dart';
import 'package:wisofttask/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

GlobalKey<NavigatorState> navigationKey = GlobalKey();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppController>(create: (BuildContext context) => AppController()),
        ChangeNotifierProvider<LocationHelperProvider>(create: (BuildContext context) => LocationHelperProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigationKey,
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: SplashScreen.Route,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
