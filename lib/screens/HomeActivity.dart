import 'package:fasttrackgarage_app/utils/RoutesName.dart';
import 'package:flutter/material.dart';
import 'ServiceHistoryActivity.dart';
import 'OutletActivity.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'InventoryCheckActivity.dart';
import 'ServiceActivity.dart';
import 'package:fasttrackgarage_app/utils/AppBarWithTitle.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Home'),
          automaticallyImplyLeading: false,
          backgroundColor: Color(ExtraColors.DARK_BLUE),
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
                                  "images/cart.png",
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
                                    builder: (context) =>
                                        InventoryCheckActivity()),
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
              ]),
        ));
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
}
