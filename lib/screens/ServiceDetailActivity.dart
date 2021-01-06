import 'package:fasttrackgarage_app/utils/Constants.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceDetailActivity extends StatefulWidget {
  String serviceTitle, body, image;
  ServiceDetailActivity(this.serviceTitle, this.body, this.image);
  @override
  _ServiceDetailActivityState createState() => _ServiceDetailActivityState();
}

class _ServiceDetailActivityState extends State<ServiceDetailActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.serviceTitle),
        backgroundColor: Color(ExtraColors.DARK_BLUE),
      ),
      backgroundColor: Color(0xff094F9A),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: 55,
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
          child: Text(
            "Call now",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(0xffFBAB54),
          onPressed: () {
            onCallPressed();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(15, 30, 0, 20),
            child: Row(
              children: <Widget>[
                Image.asset(widget.image),
                Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.serviceTitle,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    )),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
              child: Text(
                widget.body,
                textAlign: TextAlign.justify,
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
    );
  }

  onCallPressed() async {
    final prefs = await SharedPreferences.getInstance();
    String phnNum = await prefs.getString(Constants.NEAREST_STORE_PHONENO).replaceAll(new RegExp(r"\s+\b|\b\s"), "");

    var url = "tel:$phnNum";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
