import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:wisofttask/models/Address.dart';
import 'package:wisofttask/models/Order.dart';

class LocationHelperProvider extends ChangeNotifier {
  Location location = Location();
  LocationData? pickedLocationData;
  bool? hasPermission;
  bool? serviceEnabled;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  AddressCoordinates? currentAddressCoordinates;

  late GoogleMapController mapsController;
  static final CameraPosition kLake = CameraPosition(target: LatLng(30.3753, 69.3451), zoom: 18);

  void init() async {
    this.hasPermission = _hasLocationAccessible(await location.hasPermission());
    this.serviceEnabled = await location.serviceEnabled();
  }

  void requestPermission(BuildContext context) async {
    PermissionStatus permissionStatus = await this.location.requestPermission();
    this.hasPermission = _hasLocationAccessible(permissionStatus);
    if (hasPermission ?? false) {
      this.serviceEnabled = await location.requestService();
      if (serviceEnabled ?? false) {
        initalizeCurrentLocation(context);
      }
    }
    notifyListeners();
  }

  void setDestinationMarker(Order order) {
    MarkerId markerId = MarkerId('dest');
    Marker marker = Marker(markerId: markerId, position: LatLng(order.customer.addressCoordinates.lat, order.customer.addressCoordinates.lon));
    markers[markerId] = marker;
    notifyListeners();
  }

  void clearDestinationMarkers() {
    markers.clear();
    polylines.clear();
  }

  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};

  void getPolyLines(Order order) async {
    List<LatLng> polylineCoordinates = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyDE0rig2LM6GIgeTu5HK595HAJwMm_rqyI',
      PointLatLng(this.currentAddressCoordinates!.lat, this.currentAddressCoordinates!.lon),
      PointLatLng(order.customer.addressCoordinates.lat, order.customer.addressCoordinates.lon),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    _addPolyLine(polylineCoordinates);
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.green,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    notifyListeners();
  }

  void initalizeCurrentLocation(BuildContext context) async {
    if (pickedLocationData == null) {
      pickedLocationData = await location.getLocation();
      if (pickedLocationData == null) return;
      this.currentAddressCoordinates = await geocodeLocation(LatLng(pickedLocationData!.latitude!, pickedLocationData!.longitude!));
      print('Location fetched');
      notifyListeners();
    }
  }

  Future<AddressCoordinates?> geocodeLocation(LatLng data) async {
    var Response = await http.get(Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=${data.latitude},${data.longitude}&key=AIzaSyDE0rig2LM6GIgeTu5HK595HAJwMm_rqyI'));
    var decodedJson = jsonDecode(Response.body);
    if (decodedJson == null || Response.statusCode != 200) return null;
    String formatedAddress = decodedJson['results'][0]['formatted_address'].toString();
    return AddressCoordinates.current(formatedAddress, data.latitude, data.longitude);
  }

  void clear() {
    hasPermission = false;
    serviceEnabled = false;
  }

  bool _hasLocationAccessible(PermissionStatus status) {
    return status == PermissionStatus.grantedLimited || status == PermissionStatus.granted;
  }
}
