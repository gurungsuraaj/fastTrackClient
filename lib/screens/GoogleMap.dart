import 'dart:async';

import 'package:fasttrackgarage_app/screens/InventoryCheckActivity.dart';
import 'package:fasttrackgarage_app/utils/AppBarWithTitle.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapActivity extends StatefulWidget {
  double longitude;
  double latidude;
  String name;
  GoogleMapActivity(this.longitude, this.latidude,this.name);
  @override
  _GoogleMapState createState() => _GoogleMapState();
}

class _GoogleMapState extends State<GoogleMapActivity> {
  Completer<GoogleMapController> _controller = Completer();
  LatLng _center;

  @override
  void initState() {
    super.initState();
    _center = LatLng(widget.latidude, widget.longitude);
  }

  GoogleMapController mapController;
  @override
  Widget build(BuildContext context) {
    Marker outletLocation = Marker(
      markerId: MarkerId('Pokhara'),
      position: _center,
      infoWindow: InfoWindow(title: '${widget.name}'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      ),
    );
    return Scaffold(
      appBar: AppBarWithTitle.getAppBar('Location'),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: GoogleMap(
              initialCameraPosition: new CameraPosition(
                bearing: 270.0,
                target: _center,
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
}
