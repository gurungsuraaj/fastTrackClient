import 'dart:async';

import 'package:fasttrackgarage_app/utils/AppBarWithTitle.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapActivity extends StatefulWidget {
  @override
  _GoogleMapState createState() => _GoogleMapState();
}

class _GoogleMapState extends State<GoogleMapActivity> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
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
                target: LatLng(28.2096, 83.9856),
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
