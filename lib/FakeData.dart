import 'package:flutter/material.dart';
import 'package:wisofttask/models/Address.dart';
import 'package:wisofttask/models/Customer.dart';
import 'package:wisofttask/models/Product.dart';

class FakeData {
  static List<Product> get products {
    return [
      Product(1, 'Burger', 'Item subtitle lorem ipsum some dummy text', 11, 0, Colors.blue),
      Product(2, 'Zinger', 'Item subtitle lorem ipsum some dummy text', 4, 0, Colors.greenAccent),
      Product(3, 'Pizza', 'Item subtitle lorem ipsum some dummy text', 6, 0, Colors.amberAccent),
      Product(4, 'Wings', 'Item subtitle lorem ipsum some dummy text', 15, 0, Colors.blueGrey),
      Product(5, 'Cake', 'Item subtitle lorem ipsum some dummy text', 14, 0, Colors.cyanAccent),
      Product(6, 'Coffee', 'Item subtitle lorem ipsum some dummy text', 12, 0, Colors.green),
      Product(7, 'Hot Dog', 'Item subtitle lorem ipsum some dummy text', 7, 0, Colors.brown),
      Product(8, 'Appetizer', 'Item subtitle lorem ipsum some dummy text', 10, 0, Colors.deepPurple),
      Product(9, 'Cereals', 'Item subtitle lorem ipsum some dummy text', 40, 0, Colors.lightGreen),
      Product(10, 'Legumes', 'Item subtitle lorem ipsum some dummy text', 32, 0, Colors.tealAccent),
      Product(11, 'Fish', 'Item subtitle lorem ipsum some dummy text', 4, 0, Colors.purple),
      Product(12, 'Pasta', 'Item subtitle lorem ipsum some dummy text', 10, 0, Colors.orange),
      Product(13, 'Macroni', 'Item subtitle lorem ipsum some dummy text', 17, 0, Colors.redAccent),
      // Product(14, 'Item Name 14', 'Item subtitle lorem ipsum some dummy text', 25, 0, Colors.deepPurpleAccent),
      // Product(15, 'Item Name 15', 'Item subtitle lorem ipsum some dummy text', 50, 0, Colors.white38),
      // Product(16, 'Item Name 16', 'Item subtitle lorem ipsum some dummy text', 85, 0, Colors.grey),
      // Product(17, 'Item Name 17', 'Item subtitle lorem ipsum some dummy text', 75, 0, Colors.black),
    ];
  }

  static List<Customer> get customer {
    return [
      Customer(1, 'John', '9561685503', 'maliksaif232@gmail.com', AddressCoordinates.current('International City', 25.1850099, 55.2743519)),
      Customer(2, 'Smith', '9561685503', 'jeffy.smak.jhonny@gmail.com', AddressCoordinates.current('International City', 25.1811688, 55.4132147)),
      Customer(3, 'Jeffy', '9561685503', 'jeffysmak.100@gmail.com', AddressCoordinates.current('Internet City', 25.1850099, 55.2743519)),
    ];
  }
}
