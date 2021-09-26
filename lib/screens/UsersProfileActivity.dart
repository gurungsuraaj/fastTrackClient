import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:fasttrackgarage_app/utils/PrefsManager.dart';
import 'package:fasttrackgarage_app/utils/ReusableAppBar.dart';
import 'package:fasttrackgarage_app/utils/SPUtils.dart';
import 'package:flutter/material.dart';
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
    super.initState();
    getPrefs();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(ExtraColors.scaffoldColor),
      appBar: AppBar(
        automaticallyImplyLeading: false,

        title: Center(
            child: Text("USER PROFILE",
                style: TextStyle(fontStyle: FontStyle.italic))),
        backgroundColor: Color(ExtraColors.appBarColor),
        // actions: <Widget>[],
        // leading: Container(
        //   padding: EdgeInsets.only(left: 10),
        //   child: Image.asset(
        //     'images/fastTrackSingleLogo.png',
        //     height: 25,
        //   ),
        // ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              // padding: EdgeInsets.only(left: 10),
              child: Image.asset(
                'images/fastTrack_launcher.png',
                height: 125,
              ),
            ),
            SizedBox(
              height: 20,
            ),

            Container(
              // height: 530,
              width: MediaQuery.of(context).size.width,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                // Image.asset(
                //   "images/FTProfileLogo.png",
                //   height: 150,
                //   width: 150,
                // ),
                // ReusableAppBar.getAppBar(0, 0, height, width),

                ListTile(
                  dense: true,
                  leading: Text(
                    "User Name",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  trailing: customerName == null
                      ? Container(
                          child: Text(""),
                        )
                      : Text(
                          customerName,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: new Divider(
                    thickness: 1.5,
                    color: Color(0xffef773c),
                  ),
                ),
                ListTile(
                  leading: Text(
                    "Email",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  trailing: customerEmail == null
                      ? Container(
                          child: Text(
                            "",
                          ),
                        )
                      : Text(
                          customerEmail,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: new Divider(
                    thickness: 1.5,
                    color: Color(0xffef773c),
                  ),
                ),
                ListTile(
                  leading: Text(
                    "Customer No.",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  trailing: customerNumber == null
                      ? Container(
                          child: Text(""),
                        )
                      : Text(
                          customerNumber,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: new Divider(
                    thickness: 1.5,
                    color: Color(0xffef773c),
                  ),
                ),
                ListTile(
                  leading: Text(
                    "Phone No.",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  trailing: mobNumber == null
                      ? Container(
                          child: Text(""),
                        )
                      : Text(
                          mobNumber,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: new Divider(
                    thickness: 1.5,
                    color: Color(0xffef773c),
                  ),
                ),
              ]),
            ),
            // Spacer(),
            SizedBox(
              height: 40,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: 35,
              child: FloatingActionButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18))),
                child: Text(
                  "Log Out",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Color(0xffef773c),
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
      //     backgroundColor: Color(ExtraColors.darkBlue),
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

  Future<void> getPrefs() async {
    customerName = SpUtil.getString((Constants.customerName));
    mobNumber = SpUtil.getString((Constants.customerMobileNo));
    customerEmail = SpUtil.getString((Constants.customerEmail));
    customerNumber = SpUtil.getString(Constants.customerNo);
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
