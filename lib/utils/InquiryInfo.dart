import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InquiryInfo {
  static callWidget(BuildContext context) async {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () async {
              var whatsappUrl = "whatsapp://send?phone=9806522695";
              await canLaunch(whatsappUrl)
                  ? launch(whatsappUrl)
                  : showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          contentPadding: EdgeInsets.all(10.0),
                          actions: <Widget>[
                            Container(
                              width: 100,
                              child: FlatButton(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 35, 0, 20),
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
            },
            child: Image.asset(
              'images/whatsapp.png',
              width: 50,
              height: 50,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          InkWell(
            onTap: () async {
              const url = "tel:+971553425400";
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            child: Image.asset(
              'images/phone.png',
              width: 50,
              height: 50,
            ),
          )
        ],
      ),
    );
  }
}
