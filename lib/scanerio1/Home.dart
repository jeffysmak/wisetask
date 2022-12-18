import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wisofttask/Constants.dart';
import 'package:wisofttask/OrderStatus.dart';
import 'package:wisofttask/controllers/AppController.dart';
import 'package:wisofttask/controllers/LocationHelperProvider.dart';
import 'package:wisofttask/models/Address.dart';
import 'package:wisofttask/models/Order.dart';
import 'package:wisofttask/scanerio1/OrderDetailed.dart';

class HomeScreen extends StatefulWidget {
  static const Route = '/home1';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AppController appController;
  ValueNotifier<int> _subscreenNotifier = ValueNotifier(0);

  List<Widget> screens = [OrdersScreen(), AnalyticsScreen(), AnalyticsScreen()];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () => Provider.of<AppController>(context, listen: false).schedule(context));
  }

  @override
  Widget build(BuildContext context) {
    appController = Provider.of<AppController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Truck App'),
      ),
      body: ValueListenableBuilder(valueListenable: _subscreenNotifier, builder: (_, int i, __) => screens[i]),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: _subscreenNotifier,
        builder: (_, int i, __) {
          return BottomNavigationBar(
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.outdoor_grill), label: 'Orders'),
              BottomNavigationBarItem(icon: Icon(Icons.outdoor_grill), label: 'Analytics'),
              // BottomNavigationBarItem(icon: Icon(Icons.outdoor_grill), label: 'Travel'),
            ],
            currentIndex: i,
            onTap: (v) => _subscreenNotifier.value = v,
          );
        },
      ),
    );
  }
}

class OrdersScreen extends StatelessWidget {
  late AppController appController;

  @override
  Widget build(BuildContext context) {
    appController = Provider.of<AppController>(context);
    return Container(
      child: Builder(builder: (context) {
        if (appController.orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                Icon(Icons.notifications_none, size: 56, color: Theme.of(context).dividerColor.withOpacity(0.25)),
                Text(
                  'No orders yet',
                  style: Theme.of(context).textTheme.headline5!.copyWith(color: Theme.of(context).dividerColor.withOpacity(0.25)),
                ),
                Spacer(),
                Text('a fake order will be created after every 45 seconds', style: Theme.of(context).textTheme.caption),
                const SizedBox(height: 25),
              ],
            ),
          );
        }
        return ListView.separated(
          separatorBuilder: (_, i) => Divider(height: 1),
          itemBuilder: (_, idex) {
            Order order = appController.orders[idex];
            return Material(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, OrderDetailed.Route, arguments: {'order': order});
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            Text(DateFormat('yyyy MMM').format(order.orderDateTime), style: Theme.of(context).textTheme.bodyText1),
                            const SizedBox(height: 6),
                            Text(DateFormat('d').format(order.orderDateTime), style: Theme.of(context).textTheme.headline6),
                            const SizedBox(height: 6),
                            Text(DateFormat('hh:mm a').format(order.orderDateTime), style: Theme.of(context).textTheme.caption),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            Text('Order#00${order.orderID}'),
                            const SizedBox(height: 6),
                            Text(order.customer.name, style: Theme.of(context).textTheme.headline6),
                            const SizedBox(height: 6),
                            Text(order.customer.contat, style: Theme.of(context).textTheme.caption),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Text('${order.orderTotal} AED', style: Theme.of(context).textTheme.headline6),
                          // if (order.orderStatus != OrderStatus.placed) ...[
                          const SizedBox(height: 6),
                          DefaultTextStyle(
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                  color: appController.getorderStatusTextColor(order.orderStatus),
                                ),
                            child: AnimatedTextKit(
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  appController.getorderStatusText(order.orderStatus),
                                ),
                              ],
                              repeatForever: true,
                            ),
                          )
                          // ],
                        ],
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: appController.orders.length,
        );
      }),
    );
  }
}

class AnalyticsScreen extends StatelessWidget {
  int touchedIndex = -1;
  late AppController appController;

  @override
  Widget build(BuildContext context) {
    appController = Provider.of<AppController>(context);
    return Container(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Most Popular Items', style: Theme.of(context).textTheme.headline6),
            ),
            AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: appController.chartData,
                ),
              ),
            ),
            ...appController.topSellingItems.map(
              (e) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    children: [
                      Expanded(child: Container(child: Icon(Icons.circle, color: e.keys.first.color), alignment: Alignment.centerRight), flex: 4),
                      const SizedBox(width: 12),
                      Expanded(child: Text(e.keys.first.title), flex: 6),
                    ],
                    mainAxisSize: MainAxisSize.min,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  static const Route = '/map';
  Order order;

  MapScreen(this.order);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late AppController appController;

  late LocationHelperProvider locationHelperProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<LocationHelperProvider>(context, listen: false).setDestinationMarker(widget.order);
      Provider.of<LocationHelperProvider>(context, listen: false).getPolyLines(widget.order);
    });
  }

  @override
  void dispose() {
    Provider.of<LocationHelperProvider>(context, listen: false).clearDestinationMarkers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appController = Provider.of<AppController>(context);
    locationHelperProvider = Provider.of<LocationHelperProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if ((locationHelperProvider.hasPermission ?? false) && (locationHelperProvider.serviceEnabled ?? false)) ...[
              if (locationHelperProvider.pickedLocationData != null) ...[
                Expanded(
                  child: GoogleMap(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    tiltGesturesEnabled: false,
                    compassEnabled: false,
                    markers: Set<Marker>.of(locationHelperProvider.markers.values).toSet(),
                    initialCameraPosition: LocationHelperProvider.kLake,
                    mapType: MapType.normal,
                    myLocationButtonEnabled: false,
                    polylines: Set<Polyline>.of(locationHelperProvider.polylines.values),
                    onMapCreated: (GoogleMapController controller) async {
                      locationHelperProvider.mapsController = controller;
                      locationHelperProvider.mapsController.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: LatLng(locationHelperProvider.pickedLocationData!.latitude!, locationHelperProvider.pickedLocationData!.longitude!),
                            zoom: 17,
                          ),
                        ),
                      );
                    },
                    myLocationEnabled: true,
                    zoomControlsEnabled: false,
                    mapToolbarEnabled: false,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Material(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Order#00${widget.order.orderID}',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                              ListTile(
                                leading: Icon(Icons.location_on, size: 16),
                                dense: true,
                                title: Text('From (Current Location)'),
                                subtitle: Text(locationHelperProvider.currentAddressCoordinates != null ? locationHelperProvider.currentAddressCoordinates!.address : '...'),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(child: Center(child: VerticalDivider(thickness: 1.5, width: 1)), height: 32, width: 50),
                              FutureBuilder(
                                future: locationHelperProvider.geocodeLocation(LatLng(widget.order.customer.addressCoordinates.lat, widget.order.customer.addressCoordinates.lat)),
                                builder: (_, AsyncSnapshot<AddressCoordinates?> data) {
                                  if (data.data == null) {
                                    return SizedBox(width: 45, height: 45, child: Center(child: CircularProgressIndicator()));
                                  }
                                  return ListTile(
                                    dense: true,
                                    leading: Icon(Icons.location_on, size: 16),
                                    title: Text('To (Order Destination)'),
                                    subtitle: Text(data.data!.address),
                                  );
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Constants.showMessage(context, 'This button does nothing', true);
                                        },
                                        child: Text('Start'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Expanded(
                  child: Center(
                    child: SizedBox(height: 25, width: 25, child: CircularProgressIndicator()),
                  ),
                ),
              ],
            ] else ...[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    children: [
                      const SizedBox(height: 75),
                      Icon(Icons.location_off, size: 56, color: Theme.of(context).dividerColor.withOpacity(0.5)),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        child: Text(
                          'Need to enable location Lorem Ipsum is simply dummy text of the printing and typesetting industry',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => locationHelperProvider.requestPermission(context),
                                child: Text('Allow'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Discard'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
