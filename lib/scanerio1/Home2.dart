import 'package:flutter/material.dart';
import 'package:wisofttask/scanerio1/Home.dart';

class Home2 extends StatelessWidget {
  static const Route = '/home2';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: OrdersScreen(),
    );
  }
}
