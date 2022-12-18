import 'package:flutter/material.dart';
import 'package:wisofttask/dashboard.dart';

class SplashScreen extends StatefulWidget {
  static const Route = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushNamedAndRemoveUntil(context, DashboardScreen.Route, (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('SPLASH SCREEN')),
    );
  }
}
