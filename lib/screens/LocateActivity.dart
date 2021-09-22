import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:fasttrackgarage_app/utils/Rcode.dart';
import 'package:fasttrackgarage_app/utils/Toast.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models//LocateModel.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LocateActivity extends StatefulWidget {
  final double userLong;
  final double userLat;
  LocateActivity({Key key, this.userLong, this.userLat}) : super(key: key);

  @override
  _LocateActivityState createState() => _LocateActivityState();
}

class _LocateActivityState extends State<LocateActivity> {
  double longitude = 23.11;
  double latitude = 25.22;
  List<LocateModel> locationlist = <LocateModel>[];
  bool isProgressBarShown = false;

  @override
  void initState() {
    super.initState();
    getBranchList();
    // calculateOpeningHour();
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
        fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff05135b),
          
          title: Text("LOCATE A BRANCH", style: TextStyle(fontStyle: FontStyle.italic)),
        ),
        
        backgroundColor: Color(0xff0c2d8a),
        
        
        body: ModalProgressHUD(
          
          inAsyncCall: isProgressBarShown,
          child: ListView.builder(
            itemCount: locationlist.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                
                color: Color(0xff0c2d8a),
                elevation: 0,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(15, 10, 15, 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        child: Text("Branch Name :",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color:Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    
                                    Expanded(
                                      child: Container(
                                        child: Text(locationlist[index].name,
                                            style: textStyle),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                          child: Text("Address :",
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color:Colors.white,
                                                  fontWeight: FontWeight.bold))),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      // flex: 4,
                                      child: Container(
                                        child: Text(
                                          locationlist[index].address,
                                          style: textStyle,
                                          softWrap: true,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                          child: Text("Telephone No. :",
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color:Colors.white,
                                                  fontWeight: FontWeight.bold))),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          var url =
                                              "tel:${locationlist[index].telephone}";
                                          if (await canLaunch(url)) {
                                            await launch(url);
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        },
                                        child: Container(
                                          child: Text(
                                            locationlist[index].telephone,
                                            style: textStyle,
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        child: Text("Opening Hours :",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color:Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                            locationlist[index].openinghours,
                                            style: textStyle),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                        height: 32,
                                        width: 100,
                                        decoration: new BoxDecoration(
                                          color:
                                              locationlist[index].openingStatus
                                                  ? Color(0xff7fc24c)
                                                  : Colors.red,
                                          borderRadius:
                                              new BorderRadius.circular(15.0),
                                        ),
                                        child: new Center(
                                          child: Text(
                                            locationlist[index].openingStatus
                                                ? "Open"
                                                : "Closed",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        )),
                                    SizedBox(width: 8),
                                    // Container(
                                    //   child: InkWell(
                                    //     onTap: () async {
                                    //       var location = locationlist[index]
                                    //           .latlng
                                    //           .split(",");
                                    //       double longitude =
                                    //           double.parse(location[0]);
                                    //       double latitude =
                                    //           double.parse(location[1]);
                                    //       Navigator.push(
                                    //         context,
                                    //         MaterialPageRoute(
                                    //             builder: (context) =>
                                    //                 GoogleMapActivity(
                                    //                     latitude,
                                    //                     longitude,
                                    //                     locationlist[index]
                                    //                         .name)),
                                    //       );
                                    //     },
                                    //     child: new Container(
                                    //         height: 32,
                                    //         width: 100,
                                    //         decoration: new BoxDecoration(
                                    //           color:
                                    //               Color(ExtraColors.darkBlue),
                                    //           borderRadius:
                                    //               new BorderRadius.circular(
                                    //                   10.0),
                                    //         ),
                                    //         child: new Center(
                                    //           child: Text(
                                    //             "Show Map",
                                    //             style: TextStyle(
                                    //                 fontSize: 16,
                                    //                 fontWeight: FontWeight.bold,
                                    //                 color: Colors.white),
                                    //           ),
                                    //         )),
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   width: 10,
                                    // ),
                                    Container(
                                      child: new Container(
                                        alignment: Alignment.center,
                                        height: 32.0,
                                        width: 150,
                                        decoration: new BoxDecoration(
                                          color: Color(0xffef773c),
                                          // border: new Border.all(
                                          //     color: Colors.white,
                                          //     width: 6.0),
                                          borderRadius:
                                              new BorderRadius.circular(15.0),
                                        ),
                                        child: InkWell(
                                          onTap: () async {
                                            var location = locationlist[index]
                                                .latlng
                                                .split(",");
                                            double longitude =
                                                double.parse(location[0]);
                                            double latitude =
                                                double.parse(location[1]);
                                            debugPrint(
                                                "here is the location $longitude , $latitude");
                                            if (await canLaunch(
                                                locationlist[index]
                                                    .googlemap)) {
                                              await launch(locationlist[index]
                                                  .googlemap);
                                            }
                                          },
                                          child: new Center(
                                            child: Text(
                                              "Show on Google Map",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left:15.0,right:15.0),
                      child: new Divider(
                        thickness: 2.0,
                        color: Color(0xffef773c),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }

  //Fetches the locations of branch ,
  //calculates the distance beetween user and branch and adds in distance field
  //stores in the locationList variable
  //If user geolocation is available then sorts according to distance
  getBranchList() async {
    // String url = "";
    Map<String, String> header = {
      "Content-Type": "application/json",
    };
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      showProgressBar();
      await http
          .get('http://www.fasttrackemarat.com/feed/updates.json',
              headers: header)
          .then((res) {
        int status = res.statusCode;

        if (status == Rcode.successCode) {
          hideProgressBar();
          var result = json.decode(res.body);
          var branches = result['branches'] as List;
          debugPrint("$branches");

          locationlist = branches
              .map<LocateModel>((json) => LocateModel.fromJson(json,
                  latitude: widget.userLat, longitude: widget.userLong))
              .toList();

          if (widget.userLat != null && widget.userLong != null) {
            print('--------------no location !!------------');
            locationlist.sort((a, b) => a.distance.compareTo(b.distance));
          }
        } else {
          hideProgressBar();
        }
      });
    } else {
      ShowToast.showToast(context, "No internet connection");
    }
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

  // void calculateOpeningHour() async {
  //   final startTime = DateTime(2020, 8, 23, 01, 30);
  //   final endTime = DateTime(2020, 10, 23, 13, 00);

  //   DateFormat dateFormat = DateFormat("HH:mm");
  //   DateTime now = DateTime.now();
  //   final time = dateFormat.parse(DateFormat.Hm().format(now));
  //   String dateFromAPI = "08:00 am - 11:00 pm";

  //   String openingTime = dateFromAPI.substring(0, 6);
  //   String closingTime = dateFromAPI.substring(11, 16);
  //   String updatedClosingTime;

  //   String extractPM =
  //       dateFromAPI.substring((dateFromAPI.length - 2), dateFromAPI.length);
  //   if (extractPM == "pm") {
  //     String finalTime =
  //         ((int.parse(closingTime.substring(0, 2)) + 12)).toString();
  //     updatedClosingTime = "$finalTime:${closingTime.substring(3, 5)}";
  //   } else {}

  //   final prevDate = dateFormat.parse(openingTime);
  //   final afterDate = dateFormat.parse(updatedClosingTime);

  //   if (time.isAfter(prevDate) && time.isBefore(afterDate)) {
  //   }
  // }
}
