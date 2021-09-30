import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:fasttrackgarage_app/models/LocateModel.dart';
import 'package:fasttrackgarage_app/utils/Rcode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StoreLocationScreen extends StatefulWidget {
  @override
  _StoreLocationScreenState createState() => _StoreLocationScreenState();
}

class _StoreLocationScreenState extends State<StoreLocationScreen> {
  int shortDistanceIndex;
  double shortDistBranchlat = 0;
  double shortDistBranchLong = 0;
  List<LocateModel> branchList = [];
  List<double> branchDistanceList = [];
  // Completer<GoogleMapController> _controller = Completer();
  String storeLatLong;
  LatLng _center;
  GoogleMapController mapController;
  bool isProgressBarShown = false;

  @override
  void initState() {
    _center = LatLng(0, 0);
    super.initState();
    fetchBranchList();
  }

  @override
  Widget build(BuildContext context) {
    Marker outletLocation = Marker(
      markerId: MarkerId('Pokhara'),
      position: _center,
      infoWindow: InfoWindow(
          title: shortDistanceIndex == null
              ? ""
              : "${branchList[shortDistanceIndex].address}"),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Store Location"),
        backgroundColor: Color(ExtraColors.darkBlueAccent),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isProgressBarShown,

        
        child: Stack(
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
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void calculateDistance() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    for (LocateModel branch in branchList) {
      var location = branch.latlng.split(",");
      double branchLatitude = double.parse(location[0]);
      double branchLongitude = double.parse(location[1]);

      double distanceInMeters = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          branchLatitude,
          branchLongitude);

      branchDistanceList.add(distanceInMeters);
    }
    shortDistanceIndex =
        branchDistanceList.indexOf(branchDistanceList.reduce(min));

    var shortestDistancebranch =
        branchList[shortDistanceIndex].latlng.split(",");
    shortDistBranchlat = double.parse(shortestDistancebranch[0]);
    shortDistBranchLong = double.parse(shortestDistancebranch[1]);

    setState(() {
      _center = LatLng(shortDistBranchlat, shortDistBranchLong);
    });

    hideProgressBar();
    zoomInMarker();
  }

  Future<void> fetchBranchList() async {
    showProgressBar();
    Map<String, String> header = {
      "Content-Type": "application/json",
    };
    await http
        .get('http://www.fasttrackemarat.com/feed/updates.json',
            headers: header)
        .then((res) {
      int status = res.statusCode;
      if (status == Rcode.successCode) {
        var result = json.decode(res.body);
        var value = result["branches"] as List;

        branchList = value
            .map<LocateModel>((json) => LocateModel.fromJson(json))
            .toList();

        calculateDistance();
      } else {
        hideProgressBar();
      }
    }).catchError((err) {
      hideProgressBar();
    });
  }

  void zoomInMarker() async {
    print("inside zoom camera $shortDistBranchlat $shortDistBranchLong");
    mapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(shortDistBranchlat, shortDistBranchLong),
            zoom: 17.0,
            bearing: 90.0,
            tilt: 45.0)))
        .then((val) {});
  }

  void showProgressBar() {
    setState(() {
      isProgressBarShown = true;
    });
  }

  void hideProgressBar() {
    setState(() {
      isProgressBarShown = false;
    });
  }
}
