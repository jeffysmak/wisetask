import 'package:flutter/material.dart';
import 'package:wisofttask/scanerio1/Home.dart';
import 'package:wisofttask/scanerio1/Home2.dart';

class DashboardScreen extends StatelessWidget {
  static const Route = '/dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, HomeScreen.Route), child: Text('Scenario 1')),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, Home2.Route), child: Text('Scenario 2')),
          ],
        ),
      ),
    );
  }
}
