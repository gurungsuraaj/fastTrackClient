import 'dart:convert';

import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:fasttrackgarage_app/utils/Rcode.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class InquiryDetailScreen extends StatefulWidget {
  InquiryDetailScreen({Key key}) : super(key: key);

  @override
  _InquiryDetailScreenState createState() => _InquiryDetailScreenState();
}

class _InquiryDetailScreenState extends State<InquiryDetailScreen> {
  String selectedWidth, selectedHeight, selectedRimSize, selectedBrand;
  List<String> widthList = List();
  List<String> heightList = List();
  List<String> rimSizeList = List();
  List<String> brandList = List();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInquiryDataForTyres();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Tyres Inquiry"),
        backgroundColor: Color(ExtraColors.DARK_BLUE),
      ),
      body: Column(children: [
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                height: 60,
                width: 170,
                child: DropdownButton(
                  hint: Text("width"),
                  isExpanded: true,
                  items: widthList.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  value: selectedWidth,
                  onChanged: (value) {
                    setState(() {
                      selectedWidth = value;
                    });
                  },
                ),
              ),
              Container(
                height: 60,
                width: 170,
                child: DropdownButton(
                  hint: Text("height"),
                  isExpanded: true,
                  items: heightList.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  value: selectedHeight,
                  onChanged: (value) {
                    setState(() {
                      selectedHeight = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                height: 60,
                width: 170,
                child: DropdownButton(
                  hint: Text("rim-size"),
                  isExpanded: true,
                  items: rimSizeList.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  value: selectedRimSize,
                  onChanged: (value) {
                    setState(() {
                      selectedRimSize = value;
                    });
                  },
                ),
              ),
              Container(
                height: 60,
                width: 170,
                child: DropdownButton(
                  hint: Text("brand"),
                  isExpanded: true,
                  items: brandList.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: selectedBrand,
                      child: new Text(value),
                    );
                  }).toList(),
                  value: selectedBrand,
                  onChanged: (value) {
                    setState(() {
                      selectedBrand = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 15),
          width: width * 0.8,
          child: TextField(
            style: TextStyle(fontSize: 16, color: Colors.white),
            controller: nameController,
            decoration: InputDecoration(
              hintText: 'Name',
              hintStyle: TextStyle(color: Color(0xffb8b8b8)),
              // enabledBorder: UnderlineInputBorder(
              //   borderSide: BorderSide(color: Colors.white),
              // ),
              // focusedBorder: UnderlineInputBorder(
              //   borderSide: BorderSide(color: Colors.white),
              // ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 15),
          width: width * 0.8,
          child: TextField(
            style: TextStyle(fontSize: 16, color: Colors.white),
            controller: phoneController,
            decoration: InputDecoration(
              hintText: 'Phone Number',
              hintStyle: TextStyle(color: Color(0xffb8b8b8)),
              // enabledBorder: UnderlineInputBorder(
              //   borderSide: BorderSide(color: Colors.white),
              // ),
              // focusedBorder: UnderlineInputBorder(
              //   borderSide: BorderSide(color: Colors.white),
              // ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 15),
          width: width * 0.8,
          child: TextField(
            style: TextStyle(fontSize: 16, color: Colors.white),
            controller: emailController,
            decoration: InputDecoration(
              hintText: 'Email',
              hintStyle: TextStyle(color: Color(0xffb8b8b8)),
              // enabledBorder: UnderlineInputBorder(
              //   borderSide: BorderSide(color: Colors.white),
              // ),
              // focusedBorder: UnderlineInputBorder(
              //   borderSide: BorderSide(color: Colors.white),
              // ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 15),
          width: width * 0.8,
          child: TextField(
            maxLines: null,
            keyboardType: TextInputType.multiline,
            style: TextStyle(fontSize: 16, color: Colors.white),
            controller: commentController,
            decoration: InputDecoration(
              hintText: 'Enter the comment',
              hintStyle: TextStyle(color: Color(0xffb8b8b8)),
              // enabledBorder: UnderlineInputBorder(
              //   borderSide: BorderSide(color: Colors.white),
              // ),
              // focusedBorder: UnderlineInputBorder(
              //   borderSide: BorderSide(color: Colors.white),
              // ),
            ),
          ),
        ),
        Center(
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 35, 0, 5),
            width: width * 0.75,
            child: RaisedButton(
              color: Color(ExtraColors.DARK_BLUE),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5.0),
                // side: BorderSide(color: Colors.black),
              ),
              onPressed: () {
                // performLogin();
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Text(
                "Continue",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // FlatButton(
          //     onPressed: () async {
          //       var whatsappUrl = "whatsapp://send?phone=9806522695";
          //       await canLaunch(whatsappUrl)
          //           ? launch(whatsappUrl) : showAlert();
          //           },
          //     child: Text("Test"))
        )
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Row(
          children: <Widget>[Image.asset('images/whatsapp.png')],
        ),
        onPressed: () {},
      ),
    );
  }

  getInquiryDataForTyres() async {
    Map<String, String> header = {
      "Content-Type": "application/json",
    };
    await http
        .get("https://fasttrackemarat.com/feed/tyre_by_tyre_size.json",
            headers: header)
        .then((res) {
      int status = res.statusCode;
      if (status == Rcode.SUCCESS_CODE) {
        var result = json.decode(res.body);

        var values = result['data'];
        setState(() {
          widthList = List<String>.from(values['width']);
          heightList = List<String>.from(values['height']);
          rimSizeList = List<String>.from(values['rim-size']);
          brandList = List<String>.from(values['brand']);
        });

        print(values);
      }
    });
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
}
