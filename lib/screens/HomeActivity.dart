import 'package:fasttrackgarage_app/models/Promo.dart';
import 'package:fasttrackgarage_app/screens/GoogleMap.dart';
import 'package:fasttrackgarage_app/screens/LocateActivity.dart';
import 'package:fasttrackgarage_app/screens/ShopNGo.dart';
import 'package:fasttrackgarage_app/utils/Constants.dart';
import 'package:fasttrackgarage_app/utils/RoutesName.dart';
import 'package:flutter/material.dart';
import '../utils/PrefsManager.dart';
import 'CheckInventory.dart';
import 'LoginActivity.dart';
import 'ServiceHistoryActivity.dart';
import 'OutletActivity.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'InventoryCheckActivity.dart';
import 'ServiceActivity.dart';
import 'package:fasttrackgarage_app/utils/AppBarWithTitle.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return HomeActivity();
  }
}

class HomeActivity extends StatefulWidget {
  @override
  _HomeActivityState createState() => _HomeActivityState();
}

class _HomeActivityState extends State<HomeActivity> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Promo> promoList = new List<Promo>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Home'),
          automaticallyImplyLeading: false,
          backgroundColor: Color(ExtraColors.DARK_BLUE),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: choiceAction,
              itemBuilder: (BuildContext context) {
                return Constants.choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            )
          ],
        ),
        body: new Center(
          child: new GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              padding: const EdgeInsets.all(15.0),
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 4.0,
              children: <Widget>[
                Card(
                    child: Container(
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ServiceHistoryActivity()),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "images/setting.png",
                                  height: 70,
                                  width: 50,
                                ),
                                Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text("Service History"))
                              ],
                            )))),
                Card(
                    child: Container(
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OutletActivity()),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "images/outlet.png",
                                  height: 70,
                                  width: 50,
                                ),
                                Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text("Outlet List"))
                              ],
                            )))),
                Card(
                    child: Container(
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CheckInventory()),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "images/cart.png",
                                  height: 70,
                                  width: 50,
                                ),
                                Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text("Inventory Check"))
                              ],
                            )))),
                Card(
                    child: Container(
                        child: InkWell(
                            onTap: () {
                              _showAlert();
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "images/distressCall.png",
                                  height: 70,
                                  width: 50,
                                ),
                                Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text("Distress Call"))
                              ],
                            )))),
                Card(
                    child: Container(
                        child: InkWell(
                            onTap: () {
                              showOffer();
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "images/offer.png",
                                  height: 70,
                                  width: 50,
                                ),
                                Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text("offers & Promotions"))
                              ],
                            )))),
                Card(
                    child: Container(
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ServiceActivity()),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "images/service.png",
                                  height: 70,
                                  width: 50,
                                ),
                                Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text("Service"))
                              ],
                            )))),
                Card(
                    child: Container(
                        child: InkWell(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => GoogleMapActivity()),
                              // );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LocateActivity()),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "images/locate.png",
                                  height: 70,
                                  width: 50,
                                ),
                                Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text("Locate"))
                              ],
                            )))),
                Card(
                    child: Container(
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShopAndGo()),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "images/cart.png",
                                  height: 70,
                                  width: 50,
                                ),
                                Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text("Shop N Go"))
                              ],
                            )))),
              ]),
        ));
  }

  void choiceAction(String choice) {
    if (choice == Constants.LOGOUT) {
      PrefsManager.clearSession().then((val) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginActivity()),
            ModalRoute.withName("/Login"));
      });
    }
  }

  void _showAlert() {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    AlertDialog dialog = new AlertDialog(
      contentPadding: EdgeInsets.all(0.0),
      content: Container(
        height: queryData.size.height * 0.5,
        child: Column(
          children: <Widget>[
            Container(
              height: 120,
              width: queryData.size.width,
              color: Color(ExtraColors.DARK_BLUE),
              child: Center(
                  child: Image.asset(
                "images/message.png",
                height: 90,
              )),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 35, 0, 20),
                    child: Text("Need Help?"),
                  ),
                  Container(
                    width: queryData.size.width * 0.4,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeActivity()),
                        );
                      },
                      color: Colors.blue[700],
                      child: Text(
                        'SEND SMS',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
    showDialog(context: context, child: dialog);
  }

  showOffer() async {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    Map<String, String> header = {
      "Content-Type": "application/json",
    };
    await http
        .get("http://www.fasttrackemarat.com/feed/updates.json",
            headers: header)
        .then((res) {
      var result = json.decode(res.body);
      var values = result["promo"] as List;
      promoList = values.map<Promo>((json) => Promo.fromJson(json)).toList();
      debugPrint("${promoList[0].name}");
    });
    AlertDialog dialog = new AlertDialog(
      contentPadding: EdgeInsets.all(0.0),
      content: Container(
        height: queryData.size.height * 0.36,
        child: Column(
          children: <Widget>[
            Container(
              width: queryData.size.width,
              color: Color(ExtraColors.DARK_BLUE),
              child: Image.network(
                promoList[0].banner,
                fit: BoxFit.fill,
                height: 160,
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: Text(
                      promoList[0].name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(25, 15, 0, 0),
                    child: Text(
                      promoList[0].details,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
    showDialog(context: context, child: dialog);
  }
}
