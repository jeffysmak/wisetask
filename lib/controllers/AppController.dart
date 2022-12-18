import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:wisofttask/Constants.dart';
import 'package:wisofttask/FakeData.dart';
import 'package:wisofttask/OrderStatus.dart';
import 'package:wisofttask/main.dart';
import 'package:wisofttask/models/Address.dart';
import 'package:wisofttask/models/Order.dart';
import "package:collection/collection.dart";
import 'package:wisofttask/models/Product.dart';

class AppController extends ChangeNotifier {
  Location location = Location();
  LocationData? pickedLocationData;
  bool? hasPermission;
  bool? serviceEnabled;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<CircleId, Circle> circles = <CircleId, Circle>{};
  AddressCoordinates? addressCoordinates;

  /* Orders Controls */
  List<Order> orders = List.empty(growable: true);

  Future<void> schedule(BuildContext context) async {
    Future.delayed(Duration(seconds: 45), () => makeOrder(context));
  }

  Future<void> makeOrder(BuildContext context) async {
    orders.add(
      Order(
        orders.length + 1,
        DateTime.now(),
        [
          ...List.generate(
            (new Random().nextInt(FakeData.products.length - 1)) ~/ 3,
            (index) {
              Product p = FakeData.products[new Random().nextInt(FakeData.products.length - 1)];
              p.quantity = index + 1;
              return p;
            },
          ),
        ],
        FakeData.customer[new Random().nextInt(FakeData.customer.length - 1)],
      )..orderStatus = OrderStatus.placed,
    );
    orders.sort((b, a) => a.orderDateTime.compareTo(b.orderDateTime));
    notifyListeners();
    Constants.showMessage(navigationKey.currentContext!, 'You recieved an order !', true);
    schedule(navigationKey.currentContext!);
  }

  void changeStatus(OrderStatus? orderStatus, Order order) {
    if (orderStatus == null) return;
    this.orders[this.orders.indexOf(order)].orderStatus = orderStatus;
    notifyListeners();
  }

  int touchedIndex = -1;

  List<Map<Product, int>> get topSellingItems {
    List<Map<Product, int>> data = List.empty(growable: true);

    List<Product> lineItems = List.empty(growable: true);
    orders.forEach((element) => lineItems.addAll(element.products));
    Map<int, List<Product>> groupedBy = groupBy(lineItems, (Product p) => p.id);

    groupedBy.forEach((key, value) {
      List<Product> totalItems = value;
      int numberOfItemsSold = totalItems.fold(0, (previousValue, element) => previousValue + element.quantity);
      Product item = totalItems.first;
      data.add({item: numberOfItemsSold});
    });
    data.sort((a, b) => b.values.first.compareTo(a.values.first));
    data = data.take(5).toList();
    return data;
  }

  List<PieChartSectionData> get chartData {
    var data = topSellingItems;
    int totalCount = data.fold(0, (previousValue, element) => previousValue + element.values.first);

    return data.map((Map<Product, int> e) {
      final isTouched = data.indexOf(e) == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;

      double percentAmt = (e.values.first / totalCount) * 100;
      return PieChartSectionData(
        color: e.keys.first.color,
        value: percentAmt,
        title: '${percentAmt.toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
        ),
      );
    }).toList();
  }

  OrderStatus? nextStatus(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return OrderStatus.preparing;
      case OrderStatus.preparing:
        return OrderStatus.packing;
      case OrderStatus.packing:
        return OrderStatus.Completed;
      case OrderStatus.Completed:
        return null;
    }
  }

  String statusButton(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return 'Start Preparing';
      case OrderStatus.preparing:
        return 'Start Packing';
      case OrderStatus.packing:
        return 'Mark Completed';
      case OrderStatus.Completed:
        return 'Order Completed';
    }
  }

  String getorderStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return 'Placed...';
      case OrderStatus.preparing:
        return 'Preparing...';
      case OrderStatus.packing:
        return 'Packing...';
      case OrderStatus.Completed:
        return 'Completed !';
    }
  }

  Color getorderStatusTextColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return Colors.orange;
      case OrderStatus.preparing:
        return Colors.redAccent;
      case OrderStatus.packing:
        return Colors.blue;
      case OrderStatus.Completed:
        return Colors.green;
    }
  }
}
