import 'dart:async';

import 'package:fasttrackgarage_app/utils/AppBarWithTitle.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapActivity extends StatefulWidget {
  double longitude;
  double latidude;
  GoogleMapActivity(this.longitude, this.latidude);
  @override
  _GoogleMapState createState() => _GoogleMapState();
}

class _GoogleMapState extends State<GoogleMapActivity> {
  Completer<GoogleMapController> _controller = Completer();
  double longitude;
  double latidude;
  var cordinates;
  // static final LatLng center;
  _GoogleMapState() {
    // center = LatLng(widget.longitude, widget.latidude);
  }

  @override
  void initState() {
    super.initState();
    debugPrint("+++++++++");
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
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                bearing: 270.0,
                target: LatLng(222.0, 22.2),
                zoom: 17.0,
              ),
              onMapCreated: _onMapCreated,
              markers: {outletLocation},
            ),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  Marker outletLocation = Marker(
    markerId: MarkerId('Pokhara'),
    position: LatLng(28.2096, 83.9856),
    infoWindow: InfoWindow(title: 'Bur Dubai, mankhod road'),
    icon: BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueRed,
    ),
  );
}
