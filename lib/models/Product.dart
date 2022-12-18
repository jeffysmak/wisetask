import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Product extends Equatable {
  int id;
  String title;
  String subtitle;
  int price;
  int quantity;
  Color color;

  Product(this.id, this.title, this.subtitle, this.price, this.quantity,this.color);

  @override
  List<Object?> get props => [id];

// getters or setters
}
