import 'package:equatable/equatable.dart';
import 'package:wisofttask/models/Address.dart';

class Customer extends Equatable{

  int id;
  String name;
  String contat;
  String email;
  AddressCoordinates addressCoordinates;

  Customer(this.id, this.name, this.contat, this.email, this.addressCoordinates);

  @override
  List<Object?> get props => [id];
}