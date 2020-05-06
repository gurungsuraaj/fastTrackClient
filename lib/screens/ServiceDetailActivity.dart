import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:flutter/material.dart';

class ServiceDetailActivity extends StatefulWidget {
  String serviceTitle;
  ServiceDetailActivity(this.serviceTitle);
  @override
  _ServiceDetailActivityState createState() => _ServiceDetailActivityState();
}

class _ServiceDetailActivityState extends State<ServiceDetailActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Service Info"),
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
              child: Text(" Your auto air conditioner has one job: to keep you comfortable in the heat. Your A/C compressor is also responsible for assisting with removing moisture from the cabin of your car to keep the windows clear when you turn on the “defrost” function? Whether you’re concerned about windshield visibility, keeping the environment safe, or just being comfortable in your car during the heat of summer, be sure to get all of your auto air conditioning components checked before something breaks. So, stop on by today and have our expertly trained and Certified mechanics at Fasttrack - Emarat service your car’s Air Conditioning.",textAlign: TextAlign.justify, style: TextStyle(color: Colors.white),))


        ],
      ),
    );
  }
}
