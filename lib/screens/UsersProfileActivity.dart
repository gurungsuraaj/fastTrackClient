import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:fasttrackgarage_app/utils/PrefsManager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fasttrackgarage_app/utils/Constants.dart';

import 'LoginActivity.dart';

class UsersProfileActivity extends StatefulWidget {
  @override
  _UsersProfileActivityState createState() => _UsersProfileActivityState();
}

class _UsersProfileActivityState extends State<UsersProfileActivity> {
  String customerName, mobNumber;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile"),
        backgroundColor: Color(ExtraColors.DARK_BLUE_ACCENT),
        actions: <Widget>[],
        leading: Container(
          padding: EdgeInsets.only(left: 10),
          child: Image.asset(
            'images/fastTrackSingleLogo.png',
            height: 25,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                  child: Icon(
                Icons.perm_identity,
                size: 120,
                color: Color(ExtraColors.DARK_BLUE_ACCENT),
              )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                 customerName == null ? Container(): Text(
                    customerName,
                    style: TextStyle(fontSize: 18),
                  ),
                  mobNumber== null ? Container(): Text(mobNumber, style: TextStyle(fontSize: 18))
                ],
              )
            ],
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 55,
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Text(
            "Log Out",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(ExtraColors.DARK_BLUE),
          onPressed: () {
            PrefsManager.clearSession().then((val) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginActivity()),
                  ModalRoute.withName("/Login"));
            });
          },
        ),
      ),
    );
  }

  Future<String> getPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    customerName = await prefs.getString((Constants.CUSTOMER_NAME));
    mobNumber = await prefs.getString((Constants.CUSTOMER_MOBILE_NO));

    //  return serviceOrderNum;
  }
}
