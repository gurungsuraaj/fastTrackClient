import 'dart:async';

import 'package:fasttrackgarage_app/utils/AppBarWithTitle.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapActivity extends StatefulWidget {
  @override
  _GoogleMapState createState() => _GoogleMapState();
}

class _GoogleMapState extends State<GoogleMapActivity> {
  Completer<GoogleMapController> _controller = Completer();
  static double lat;
  static double long;
  LatLng _center ;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
   /* getUserLocation().then((val) {
      lat = val.latitude.toDouble();
      long = val.longitude.toDouble();
      debugPrint("This is latitude : $lat");
      debugPrint("This is longitude : $long");

    });*/
  }

  GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithTitle.getAppBar('Location'),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: lat != null ? GoogleMap(
              initialCameraPosition: CameraPosition(
                bearing: 270.0,
                target: LatLng(lat,long),
                zoom: 17.0,
              ),
              onMapCreated: _onMapCreated,
              markers: {outletLocation}
            ) :  Container(),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    debugPrint("This is the value of lat : $lat");
    setState(() {
      mapController = controller;
    });
  }
  Marker outletLocation = Marker(
  markerId: MarkerId('Pokhara'),
  position: lat != null ? LatLng(lat, long) : LatLng(28.2096, 83.9856), //TODO get marker
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueRed,
  ),
);

  void getCurrentLocation() async {
    var currentLocation = LocationData;

    var location = new Location();

    location.getLocation().then((val) {
      setState(() {
        lat = val.latitude;
        long = val.longitude;
      });
    });

 /*   location.onLocationChanged().listen((LocationData currentLocation) {
      print(currentLocation.latitude);
      print(currentLocation.longitude);
    });*/
  }

/*
  Future<Position> locateUser() async {
    return Geolocator()
        .getCurrentPosition();
  }

  Future<LatLng> getUserLocation() async {
    currentLocation = await locateUser();
    setState(() {
      _center = LatLng(currentLocation.latitude, currentLocation.longitude);
    });
    return _center;
  }*/
}
