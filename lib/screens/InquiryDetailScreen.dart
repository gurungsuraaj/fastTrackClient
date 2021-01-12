import 'dart:convert';
import 'dart:math' as math;
import 'package:fasttrackgarage_app/models/MakeMode.dart';
import 'package:fasttrackgarage_app/utils/Constants.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:fasttrackgarage_app/utils/Rcode.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class InquiryDetailScreen extends StatefulWidget {
  InquiryDetailScreen({Key key}) : super(key: key);

  @override
  _InquiryDetailScreenState createState() => _InquiryDetailScreenState();
}

class _InquiryDetailScreenState extends State<InquiryDetailScreen>
    with TickerProviderStateMixin {
  String selectedWidthSize,
      selectedHeightSize,
      selectedRimSize,
      selectedBrandSize;
  List<String> widthListSize = List();
  List<String> heightListSize = List();
  List<String> rimSizeListSize = List();
  List<String> brandListSize = List();

  TextEditingController nameControllerSize = TextEditingController();
  TextEditingController phoneControllerSize = TextEditingController();
  TextEditingController emailControllerSize = TextEditingController();
  TextEditingController commentControllerSize = TextEditingController();
  bool isProgressBarShown = false;

  String selectedMakeCode, selectedModel, selectedRimModel, selectedBrandModel;
  List<String> widthListModel = List();
  List<String> heightListModel = List();
  List<String> rimSizeListModel = List();
  List<String> brandListModel = List();

  TextEditingController nameControllerModel = TextEditingController();
  TextEditingController phoneControllerModel = TextEditingController();
  TextEditingController emailControllerModel = TextEditingController();
  TextEditingController commentControllerModel = TextEditingController();
  TextEditingController dateController = TextEditingController();

  List<MakeModel> makeModelList = List();
  List<String> modelList = List();
  List<int> yearList = List();

  String selectedMake, makeDate, selectedDate;
  var _formKey = GlobalKey<FormState>();
  var _formKey1 = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AnimationController _controller;
  String nearestStorePhn,
      whatsAppNum,
      customerName,
      customerNumber,
      customerEmail;
  static const List<IconData> icons = const [Icons.whatshot, Icons.phone];

  static const List<String> imageList = const [
    "images/call.png",
    "images/whatsapp.png"
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInquiryDataForTyres().whenComplete(() async {
      getPrefs().whenComplete(() {
        getMakeList();
        getYearList();
      });
    });
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).cardColor;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
                  backgroundColor: backgroundColor,
                  mini: true,
                  // child: new Icon(icons[index], color: foregroundColor),
                  child: new Image.asset(
                    imageList[index],
                  ),
                  onPressed: () async {
                    if (index == 0) {
                      print("hello 0");
                      var url = "tel:$nearestStorePhn";
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    } else if (index == 1) {
                      print("hello 1 $whatsAppNum");
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
                backgroundColor: Color(ExtraColors.DARK_BLUE),
                heroTag: null,
                child: new AnimatedBuilder(
                  animation: _controller,
                  builder: (BuildContext context, Widget child) {
                    return new Transform(
                      transform: new Matrix4.rotationZ(
                          _controller.value * 0.5 * math.pi),
                      alignment: FractionalOffset.center,
                      child: new Icon(
                          _controller.isDismissed ? Icons.call : Icons.close),
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
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Tyres Inquiry"),
          backgroundColor: Color(ExtraColors.DARK_BLUE),
          bottom: TabBar(
            isScrollable: true,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: Colors.white),
            tabs: <Widget>[
              Tab(
                child: Text(
                  'Search By Tyre Size',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Tab(
                child: Text(
                  'Search By Car Model',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
        body: ModalProgressHUD(
          inAsyncCall: isProgressBarShown,
          child: TabBarView(
              children: [searchBySizeContainer(), searchByModelContainer()]),
        ),
      ),
    );
  }

  Future<void> getInquiryDataForTyres() async {
    showProgressBar();
    Map<String, String> header = {
      "Content-Type": "application/json",
    };
    await http
        .get("https://fasttrackemarat.com/feed/tyre_by_tyre_size.json",
            headers: header)
        .then((res) {
      hideProgressBar();
      int status = res.statusCode;
      if (status == Rcode.SUCCESS_CODE) {
        var result = json.decode(res.body);

        var values = result['data'];
        setState(() {
          widthListSize = List<String>.from(values['width']);
          heightListSize = List<String>.from(values['height']);
          rimSizeListSize = List<String>.from(values['rim-size']);
          brandListSize = List<String>.from(values['brand']);
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

  Widget searchBySizeContainer() {
    var width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(height: 20),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: 40,
                  width: width * 0.45,
                  padding: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.3),
                      borderRadius: BorderRadius.circular(5)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint: Text("width"),
                      isExpanded: true,
                      items: widthListSize.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: new Text(value)),
                        );
                      }).toList(),
                      value: selectedWidthSize,
                      onChanged: (value) {
                        setState(() {
                          selectedWidthSize = value;
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  width: width * 0.45,
                  padding: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.3),
                      borderRadius: BorderRadius.circular(5)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint: Text("height"),
                      isExpanded: true,
                      items: heightListSize.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      value: selectedHeightSize,
                      onChanged: (value) {
                        setState(() {
                          selectedHeightSize = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: 40,
                  width: width * 0.45,
                  padding: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.3),
                      borderRadius: BorderRadius.circular(5)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint: Text("rim-size"),
                      isExpanded: true,
                      items: rimSizeListSize.map((String value) {
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
                ),
                Container(
                  height: 40,
                  width: width * 0.45,
                  padding: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.3),
                      borderRadius: BorderRadius.circular(5)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint: Text("brand"),
                      isExpanded: true,
                      items: brandListSize.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      value: selectedBrandSize,
                      onChanged: (value) {
                        setState(() {
                          selectedBrandSize = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 20,
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: 60,
                  width: width * 0.45,
                  child: TextFormField(
                    validator: (value) {
                      if (value.length == 0) {
                        return ("Please fill up this field.");
                      } else {
                        return null;
                      }
                    },
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    controller: nameControllerSize,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      isDense: true,
                      labelText: 'Name',
                      hintStyle: TextStyle(color: Color(0xffb8b8b8)),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  width: width * 0.45,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.length == 0) {
                        return ("Please fill up this field.");
                      } else {
                        return null;
                      }
                    },
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    controller: phoneControllerSize,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      isDense: true,
                      labelText: 'Phone Number',
                      hintStyle: TextStyle(color: Color(0xffb8b8b8)),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 60,
            width: width * 0.94,
            child: TextFormField(
              validator: (value) {
                bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value);
                if (value.isEmpty) {
                  return 'Please fill up this field';
                } else if (!emailValid) {
                  return 'Please enter a valid address';
                }
                return null;
              },
              style: TextStyle(
                fontSize: 16,
              ),
              controller: emailControllerSize,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(8),
                isDense: true,
                labelText: 'Email',
                hintStyle: TextStyle(color: Color(0xffb8b8b8)),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Container(
            width: width * 0.94,
            child: TextFormField(
              maxLines: 5,
              validator: (value) {
                if (value.length == 0) {
                  return ("Please fill up this field.");
                } else {
                  return null;
                }
              },
              style: TextStyle(
                fontSize: 16,
              ),
              controller: commentControllerSize,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(8),
                isDense: true,
                labelText: 'Enter the Comment',
                hintStyle: TextStyle(color: Color(0xffb8b8b8)),
                border: OutlineInputBorder(),
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
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    submitTyreSizeData();
                  }
                },
                child: Text(
                  "Send",
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
          ),
          SizedBox(
            height: 30,
          ),
          // Center(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: <Widget>[
          //       InkWell(
          //         onTap: () async {
          //           var whatsappUrl = "whatsapp://send?phone=9806522695";
          //           await canLaunch(whatsappUrl)
          //               ? launch(whatsappUrl)
          //               : showAlert();
          //         },
          //         child: Image.asset(
          //           'images/whatsapp.png',
          //           width: 50,
          //           height: 50,
          //         ),
          //       ),
          //       SizedBox(
          //         width: 20,
          //       ),
          //       InkWell(
          //         onTap: () async {
          //           const url = "tel:+971553425400";
          //           if (await canLaunch(url)) {
          //             await launch(url);
          //           } else {
          //             throw 'Could not launch $url';
          //           }
          //         },
          //         child: Image.asset(
          //           'images/phone.png',
          //           width: 50,
          //           height: 50,
          //         ),
          //       )
          //     ],
          //   ),
          // ),
        ]),
      ),
    );
  }

  Widget searchByModelContainer() {
    var width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Form(
        key: _formKey1,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(height: 20),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: 40,
                  padding: EdgeInsets.only(left: 5),
                  width: width * 0.45,
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.3),
                      borderRadius: BorderRadius.circular(5)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint: Text("Select Make"),
                      isExpanded: true,
                      items: makeModelList.map((MakeModel value) {
                        return new DropdownMenuItem<String>(
                          value: value.name,
                          child: new Text(value.name),
                        );
                      }).toList(),
                      value: selectedMakeCode,
                      onChanged: (value) {
                        getModelCode(value);

                        setState(() {
                          selectedMakeCode = value;
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  width: width * 0.45,
                  padding: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.3),
                      borderRadius: BorderRadius.circular(5)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint: Text("Select Model"),
                      isExpanded: true,
                      items: modelList.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      value: selectedModel,
                      onChanged: (value) {
                        setState(() {
                          selectedModel = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          // SizedBox(height: 5),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: 60,
                  width: width * 0.45,

                  margin: EdgeInsets.only(top: 25),
                  // padding: EdgeInsets.only(top:20),

                  child: TextFormField(
                    validator: (value) {
                      if (value.length == 0) {
                        return ("Please fill up this field.");
                      } else {
                        return null;
                      }
                    },
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    controller: nameControllerModel,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      isDense: true,
                      labelText: 'Name',
                      hintStyle: TextStyle(color: Color(0xffb8b8b8)),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  width: width * 0.45,
                  padding: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.3),
                      borderRadius: BorderRadius.circular(5)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint: Text("Select Year"),
                      isExpanded: true,
                      items: yearList.map((int value) {
                        return new DropdownMenuItem<String>(
                          value: value.toString(),
                          child: new Text(value.toString()),
                        );
                      }).toList(),
                      value: selectedDate,
                      onChanged: (value) {
                        setState(() {
                          selectedDate = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          // SizedBox(
          //   height: 5,
          // ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: 60,
                  width: width * 0.45,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.length == 0) {
                        return ("Please fill up this field.");
                      } else {
                        return null;
                      }
                    },
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    controller: phoneControllerModel,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      isDense: true,
                      labelText: 'Phone Number',
                      hintStyle: TextStyle(color: Color(0xffb8b8b8)),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  width: width * 0.45,
                  child: TextFormField(
                    validator: (value) {
                      bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value);
                      if (value.isEmpty) {
                        return 'Please fill up this field';
                      } else if (!emailValid) {
                        return 'Please enter a valid address';
                      }
                      return null;
                    },
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    controller: emailControllerModel,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      isDense: true,
                      labelText: 'Email',
                      hintStyle: TextStyle(color: Color(0xffb8b8b8)),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: width * 0.94,
            child: TextFormField(
              validator: (value) {
                if (value.length == 0) {
                  return ("Please fill up this field.");
                } else {
                  return null;
                }
              },
              maxLines: 5,
              style: TextStyle(
                fontSize: 16,
              ),
              controller: commentControllerModel,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(8),
                isDense: true,
                labelText: 'Enter the comment',
                hintStyle: TextStyle(color: Color(0xffb8b8b8)),
                border: OutlineInputBorder(),
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
                  if (_formKey1.currentState.validate()) {
                    _formKey1.currentState.save();
                    submitTyresModelData();
                  }
                },
                child: Text(
                  "Send",
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
          ),
          SizedBox(
            height: 30,
          ),
        ]),
      ),
    );
  }

  getMakeList() async {
    showProgressBar();
    Map<String, String> header = {
      "Content-Type": "application/json",
    };
    await http
        .get("https://fasttrackemarat.com/feed/make-model.json",
            headers: header)
        .then((res) {
      hideProgressBar();
      int status = res.statusCode;
      if (status == Rcode.SUCCESS_CODE) {
        var result = json.decode(res.body);

        var values = result['data']["make"];

        makeModelList =
            values.map<MakeModel>((json) => MakeModel.fromJson(json)).toList();

        setState(() {});

        print(values);
      }
    });
  }

  void getModelCode(String selectedMake) async {
    makeModelList.forEach((item) {
      if (item.name == selectedMake) {
        setState(() {
          modelList = item.model;
        });
      }
    });
  }

  Future<Null> getYearList() async {
    for (int i = 1964; i <= int.parse(DateTime.now().year.toString()); i++) {
      yearList.add(i);
    }
    setState(() {});
  }

  void submitTyreSizeData() async {
    showProgressBar();

    Map<String, String> header = {
      "Content-Type": "application/json",
      "Accept": "application/json"
    };

    final body = jsonEncode({
      "tyre-width": selectedWidthSize,
      "tyre-height": selectedHeightSize,
      "rim-size": selectedRimSize,
      "car-brand": selectedBrandSize,
      "name": nameControllerSize.text,
      "email": emailControllerSize.text,
      "phone": phoneControllerSize.text,
      "message": commentControllerSize.text
    });
    await http
        .post(
            "https://fasttrackemarat.com/contact-from-app/search-by-tyre-size.php",
            headers: header,
            body: body)
        .then((res) {
      hideProgressBar();
      print(body);
      if (res.statusCode == Rcode.SUCCESS_CODE) {
        print(res.body);
        displaySnackbar(context, "Inquiry submitted successfully");
        setState(() {
          nameControllerSize.text = "";
          phoneControllerSize.text = "";
          emailControllerSize.text = "";
          commentControllerSize.text = "";
          selectedWidthSize = null;
          selectedHeightSize = null;
          selectedRimSize = null;
          selectedBrandSize = null;
        });
      } else {
        displaySnackbar(context, "Error: ${res.body}");
      }
    });
  }

  Future<void> displaySnackbar(BuildContext context, msg) {
    final snackBar = SnackBar(
      content: Text('$msg'),
      duration: const Duration(seconds: 2),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void submitTyresModelData() async {
    showProgressBar();
    Map<String, String> header = {
      "Content-Type": "application/json",
      "Accept": "application/json"
    };

    final body = jsonEncode({
      "car-brand": selectedMakeCode,
      "car-model": selectedModel,
      "year": selectedDate,
      "name": nameControllerModel.text,
      "email": emailControllerModel.text,
      "phone": phoneControllerModel.text,
      "message": commentControllerModel.text
    });
    print(body);

    await http
        .post(
            'https://fasttrackemarat.com/contact-from-app/search-by-car-model.php',
            headers: header,
            body: body)
        .then((res) {
      hideProgressBar();
      if (res.statusCode == Rcode.SUCCESS_CODE) {
        print(body);
        print(res.body);
        displaySnackbar(context, "Inquiry submitted successfully");
        setState(() {
          nameControllerModel.text = "";
          emailControllerModel.text = "";
          phoneControllerModel.text = "";
          commentControllerModel.text = "";
          selectedMakeCode = null;
          selectedModel = null;
          selectedDate = null;
        });
      } else {
        displaySnackbar(context, "Error: ${res.body}");
      }
    });
  }

  Future<void> getPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() async {
      nearestStorePhn = await prefs
          .getString(Constants.NEAREST_STORE_PHONENO)
          .replaceAll(new RegExp(r"\s+\b|\b\s"), "");
      whatsAppNum = await prefs.getString(Constants.WHATS_APP_NUMBER);
      customerName = await prefs.getString(Constants.CUSTOMER_NAME);
      customerNumber = await prefs.get(Constants.CUSTOMER_MOBILE_NO);
      customerEmail = await prefs.getString(Constants.CUSTOMER_EMAIL);

      // There are two tabs with different controller

      // Search by trye tab
      nameControllerSize.text = customerName;
      phoneControllerSize.text = customerNumber;
      emailControllerSize.text = customerEmail;

      //Search by car model
      nameControllerModel.text = customerName;
      phoneControllerModel.text = customerNumber;
      emailControllerModel.text = customerEmail;
    });
  }
}
