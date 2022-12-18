import 'package:equatable/equatable.dart';
import 'package:wisofttask/OrderStatus.dart';
import 'package:wisofttask/models/Customer.dart';
import 'package:wisofttask/models/Product.dart';

class Order extends Equatable {
  int orderID;
  DateTime orderDateTime;
  List<Product> products;
  Customer customer;
  late OrderStatus orderStatus;

  Order(this.orderID, this.orderDateTime, this.products, this.customer);

  @override
  List<Object?> get props => [orderID];

  int get orderTotal {
    return products.fold(0, (previousValue, element) => previousValue + (element.price * element.quantity));
  }
}
