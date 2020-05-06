import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:flutter/material.dart';

class ServiceDetailActivity extends StatefulWidget {
  String serviceTitle, body;
  ServiceDetailActivity(this.serviceTitle,this.body);
  @override
  _ServiceDetailActivityState createState() => _ServiceDetailActivityState();
}

class _ServiceDetailActivityState extends State<ServiceDetailActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.serviceTitle),
        backgroundColor: Color(ExtraColors.DARK_BLUE),
      ),
      backgroundColor:  Color(0xff094F9A),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: 55,
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
          child: Text(
            "Call now",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(0xffFBAB54),
          onPressed: () {
            // onContinuePressed();

          },
        ),
      ) ,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        children: <Widget>[
          Image.asset('images/AcImage.jpg'),
      Container(
        padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
          alignment: Alignment.centerLeft,
          child: Text(widget.serviceTitle,style: TextStyle(color: Colors.white,fontSize: 25),)),

          Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
              child: Text(widget.body,textAlign: TextAlign.justify, style: TextStyle(color: Colors.white),))


        ],
      ),
    );
  }
}
