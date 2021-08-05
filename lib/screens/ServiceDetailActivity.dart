import 'package:fasttrackgarage_app/utils/Constants.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:fasttrackgarage_app/utils/SPUtils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

class ServiceDetailActivity extends StatefulWidget {
  final String serviceTitle, body, image;
  ServiceDetailActivity(this.serviceTitle, this.body, this.image);
  @override
  _ServiceDetailActivityState createState() => _ServiceDetailActivityState();
}

class _ServiceDetailActivityState extends State<ServiceDetailActivity> with TickerProviderStateMixin{
  AnimationController _controller;
 
  String nearestStorePhn,
      whatsAppNum,
      customerName,
      customerNumber,
      customerEmail;

  static const List<String> imageList = const [
    "images/call.png",
    "images/whatsapp.png"
  ];

  @override
  @override
  void initState() { 
    super.initState();
     _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.serviceTitle),
        backgroundColor: Color(ExtraColors.darkBlue),
      ),
      backgroundColor: Color(0xff094F9A),
      floatingActionButton: new Column(
          mainAxisSize: MainAxisSize.min,
          children: new List.generate(imageList.length, (int index) {
            Widget child = new Container(
              height: 70.0,
              width: 56.0,
              alignment: FractionalOffset.topCenter,
              child: new ScaleTransition(
                scale: new CurvedAnimation(
                  
                  parent: _controller,
                  curve: new Interval(0.0, 1.0 - index / imageList.length / 2.0,
                      curve: Curves.easeOut),
                ),
                child: new FloatingActionButton(
                  heroTag: null,
                  backgroundColor: Colors.white,
                  mini: true,
                  // child: new Icon(icons[index], color: foregroundColor),
                  child: new Image.asset(
                    imageList[index],
                    height:30.0,
                    width:30.0
                  ),
                  onPressed: () async {
                    if (index == 0) {
                      var url = "tel:$nearestStorePhn";
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    } else if (index == 1) {
                      var whatsappUrl = "whatsapp://send?phone=$whatsAppNum";
                      await canLaunch(whatsappUrl)
                          ? launch(whatsappUrl)
                          : showAlert();
                    }
                  },
                ),
              ),
            );
            return child;
          }).toList()
            ..add(
              new FloatingActionButton(
                backgroundColor: Colors.white,
                heroTag: null,
                child: new AnimatedBuilder(
                  animation: _controller,
                  builder: (BuildContext context, Widget child) {
                    return new Transform(
                      transform: new Matrix4.rotationZ(
                          _controller.value * 0.5 * math.pi),
                      alignment: FractionalOffset.center,
                      child: new Icon(
                        
                          _controller.isDismissed ? Icons.call : Icons.close, 
                          color:Color(ExtraColors.darkBlue)),
                    );
                  },
                ),
                onPressed: () {
                  if (_controller.isDismissed) {
                    _controller.forward();
                  } else {
                    _controller.reverse();
                  }
                },
              ),
            ),
        ),
      // floatingActionButton: Container(
      //   width: MediaQuery.of(context).size.width * 0.5,
      //   height: 55,
      //   child: FloatingActionButton(
      //     shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.all(Radius.circular(25))),
      //     child: Text(
      //       "Call now",
      //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      //     ),
      //     backgroundColor: Color(0xffFBAB54),
      //     onPressed: () {
      //       onCallPressed();
      //     },
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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

   showAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(10.0),
          actions: <Widget>[
            Container(
              width: 100,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                // color: Colors.blue[700],
                child: Text(
                  'Ok',
                  style: TextStyle(
                    color: Colors.blue[700],
                  ),
                ),
              ),
            ),
          ],
          content: Container(
            height: 100,
            child: Column(
              children: <Widget>[
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 35, 0, 20),
                        child: Text(
                            "There is no whatsapp installed on your mobile device"),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // onCallPressed() async {
  //   String phnNum = SpUtil.getString(Constants.nearestStorePhoneNo)
  //       .replaceAll(new RegExp(r"\s+\b|\b\s"), "");

  //   var url = "tel:$phnNum";
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
}
