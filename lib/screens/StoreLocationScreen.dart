

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:fasttrackgarage_app/models/LocateModel.dart';
import 'package:fasttrackgarage_app/utils/Rcode.dart';
import 'package:fasttrackgarage_app/utils/RoutesName.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class StoreLocationScreen extends StatefulWidget {

  @override
  _StoreLocationScreenState createState() => _StoreLocationScreenState();
}

class _StoreLocationScreenState extends State<StoreLocationScreen> {
  int shortDistanceIndex;
  double shortDistBranchlat;
  double shortDistBranchLong;
  List<LocateModel> branchList = List();
  List<double> branchDistanceList = List();
  Completer<GoogleMapController> _controller = Completer();
  String storeLatLong;
  LatLng _center;
  GoogleMapController mapController;
  @override
  void initState() {
//    _center = LatLng(0, 0);
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    Marker outletLocation = Marker(
      markerId: MarkerId('Pokhara'),
      position: _center,
      infoWindow: InfoWindow(title: 'suraj}'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Store Location"),
        backgroundColor: Color(ExtraColors.DARK_BLUE_ACCENT),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: GoogleMap(
              zoomGesturesEnabled: true,
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

  void calculateDistance() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    for (LocateModel branch in branchList) {
      var location = branch.latlng.split(",");
      double branchLatitude = double.parse(location[0]);
      double branchLongitude = double.parse(location[1]);

      double distanceInMeters = await Geolocator().distanceBetween(
          position.latitude,
          position.longitude,
          branchLatitude,
          branchLongitude);

      branchDistanceList.add(distanceInMeters);
    }
    shortDistanceIndex =
        branchDistanceList.indexOf(branchDistanceList.reduce(min));

    print("the shorted distance is ${branchList[shortDistanceIndex].address}");

    var shortestDistancebranch =
    branchList[shortDistanceIndex].latlng.split(",");
    shortDistBranchlat = double.parse(shortestDistancebranch[0]);
    shortDistBranchLong = double.parse(shortestDistancebranch[1]);

    setState(() {
      _center = LatLng(shortDistBranchlat, shortDistBranchLong);
    });
  }


  Future<void> fetchBranchList() async {
    Map<String, String> header = {
      "Content-Type": "application/json",
    };
    await http
        .get('http://www.fasttrackemarat.com/feed/updates.json',
        headers: header)
        .then((res) {
      int status = res.statusCode;
      if (status == Rcode.SUCCESS_CODE) {
        var result = json.decode(res.body);
        var value = result["branches"] as List;

        branchList = value
            .map<LocateModel>((json) => LocateModel.fromJson(json))
            .toList();

        calculateDistance();
      }
    }).catchError((err) {
      print("Error $err ");
    });
  }

}

