import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:fasttrackgarage_app/utils/PrefsManager.dart';
import 'package:fasttrackgarage_app/utils/ReusableAppBar.dart';
import 'package:fasttrackgarage_app/utils/SPUtils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fasttrackgarage_app/utils/Constants.dart';

import 'LoginActivity.dart';

class UsersProfileActivity extends StatefulWidget {
  @override
  _UsersProfileActivityState createState() => _UsersProfileActivityState();
}

class _UsersProfileActivityState extends State<UsersProfileActivity> {
  String customerName, mobNumber, customerEmail, customerNumber;
  bool isProgressBarShown = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrefs();
  }

  @override
  Widget build(BuildContext context) {
       var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              // height: 530,
              width: MediaQuery.of(context).size.width,
              child: Card(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  // Image.asset(
                  //   "images/FTProfileLogo.png",
                  //   height: 150,
                  //   width: 150,
                  // ),
                  ReusableAppBar.getAppBar(0, 0, height, width),

                  SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    dense: true,
                    leading: Text("User Name"),
                    trailing: customerName == null
                        ? Container(
                            child: Text(""),
                          )
                        : Text(customerName),
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 10,
                  ),
                  ListTile(
                    leading: Text("Email"),
                    trailing: customerEmail == null
                        ? Container(
                            child: Text(""),
                          )
                        : Text(customerEmail),
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 10,
                  ),
                  ListTile(
                    leading: Text("Customer No."),
                    trailing: customerNumber == null
                        ? Container(
                            child: Text(""),
                          )
                        : Text(customerNumber),
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 10,
                  ),
                  ListTile(
                    leading: Text("Phone No."),
                    trailing: mobNumber == null
                        ? Container(
                            child: Text(""),
                          )
                        : Text(mobNumber),
                  ),
                ]),
              ),
            ),
            // Spacer(),
            SizedBox(
              height: 45,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 35,
              child: FloatingActionButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Text(
                  "Log Out",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                backgroundColor: Color(ExtraColors.DARK_BLUE),
                onPressed: () {
                  PrefsManager.clearSession().then((val) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginActivity()),
                        ModalRoute.withName("/Login"));
                  });
                },
              ),
            ),
          ],
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: Container(
      //   width: MediaQuery.of(context).size.width * 0.8,
      //   height: 55,
      //   child: FloatingActionButton(
      //     shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.all(Radius.circular(5))),
      //     child: Text(
      //       "Log Out",
      //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      //     ),
      //     backgroundColor: Color(ExtraColors.DARK_BLUE),
      //     onPressed: () {
      //       PrefsManager.clearSession().then((val) {
      //         Navigator.pushAndRemoveUntil(
      //             context,
      //             MaterialPageRoute(builder: (context) => LoginActivity()),
      //             ModalRoute.withName("/Login"));
      //       });
      //     },
      //   ),
      // ),
    );
  }

  Future<String> getPrefs() async {
    customerName = SpUtil.getString((Constants.CUSTOMER_NAME));
    mobNumber = SpUtil.getString((Constants.CUSTOMER_MOBILE_NO));
    customerEmail = SpUtil.getString((Constants.CUSTOMER_EMAIL));
    customerNumber = SpUtil.getString(Constants.CUSTOMER_NUMBER);
    setState(() {});
    //  return serviceOrderNum;
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
