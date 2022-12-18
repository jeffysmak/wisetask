import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wisofttask/OrderStatus.dart';
import 'package:wisofttask/controllers/AppController.dart';
import 'package:wisofttask/models/Order.dart';
import 'package:wisofttask/scanerio1/Home.dart';

class OrderDetailed extends StatelessWidget {
  static const Route = '/detail';

  Order order;

  OrderDetailed(this.order);

  late AppController appController;

  @override
  Widget build(BuildContext context) {
    appController = Provider.of<AppController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Order#00${order.orderID}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Expanded(child: Text('ITEM'), flex: 6),
                        Expanded(child: Text('PRICE', textAlign: TextAlign.end), flex: 2),
                        Expanded(child: Text('TOTAL', textAlign: TextAlign.end), flex: 2),
                      ],
                    ),
                  ),
                  Divider(height: 1),
                  ...order.products
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(e.title, style: Theme.of(context).textTheme.button),
                                    Text('X ${e.quantity}'),
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                                flex: 6,
                              ),
                              Expanded(child: Text('${e.price} AED', textAlign: TextAlign.end), flex: 2),
                              Expanded(child: Text('${e.price * e.quantity} AED', textAlign: TextAlign.end), flex: 2),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(order.customer.name, style: Theme.of(context).textTheme.headline6),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Icon(Icons.phone, size: 16, color: Theme.of(context).colorScheme.secondary),
                              const SizedBox(width: 12),
                              Text(order.customer.contat),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Icon(Icons.email, size: 16, color: Theme.of(context).colorScheme.secondary),
                              const SizedBox(width: 12),
                              Text(order.customer.email),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Icon(Icons.location_on, size: 16, color: Theme.of(context).colorScheme.secondary),
                              const SizedBox(width: 12),
                              Text(order.customer.addressCoordinates.address),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Material(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, MapScreen.Route,arguments: {'order':order});
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: ClipRRect(
                          child: Image.network(
                            'https://maps.googleapis.com/maps/api/staticmap?center=${order.customer.addressCoordinates.lat}%2C${order.customer.addressCoordinates.lon}&zoom=14&scale=2&size=600x300&maptype=roadmap&format=png&key=AIzaSyDE0rig2LM6GIgeTu5HK595HAJwMm_rqyI&markers=size:mid%7Ccolor:0x66ff00%7Clabel:%7C${order.customer.addressCoordinates.lat}%2C${order.customer.addressCoordinates.lon}',
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, MapScreen.Route,arguments: {'order':order});
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                        child: Text('Open Directions'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: order.orderStatus == OrderStatus.Completed ? null : () => appController.changeStatus(appController.nextStatus(order.orderStatus), order),
                    child: Text(
                      appController.statusButton(order.orderStatus),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
