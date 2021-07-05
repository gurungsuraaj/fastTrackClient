import 'dart:convert';
import 'dart:math' as math;
import 'package:connectivity/connectivity.dart';
import 'package:fasttrackgarage_app/models/MakeMode.dart';
import 'package:fasttrackgarage_app/utils/Constants.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:fasttrackgarage_app/utils/Rcode.dart';
import 'package:fasttrackgarage_app/utils/SPUtils.dart';
import 'package:fasttrackgarage_app/utils/Toast.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class BatteryInquiry extends StatefulWidget {
  BatteryInquiry({Key key}) : super(key: key);

  @override
  _BatteryInquiryState createState() => _BatteryInquiryState();
}

class _BatteryInquiryState extends State<BatteryInquiry>
    with TickerProviderStateMixin {
  List<String> makeList = List();
  List<String> locationList = List();
  List<String> currentBatteryList = List();

  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController currentBatteryController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  String selectedMake,
      makeDate,
      selectCurrBattery,
      selectedModel,
      selectedLocation,
      selectedYear;
  DateTime selectedDate = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  var _formKey = GlobalKey<FormState>();
  bool isProgressBarShown = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<MakeModel> makeModelList = List();
  List<String> modelList = List();
  List<int> yearList = List();
  AnimationController _controller;
  String nearestStorePhn, whatsAppNum;

  static const List<String> imageList = const [
    "images/call.png",
    "images/whatsapp.png"
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInquiryDataForBatttery().whenComplete(() async {
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
    var width = MediaQuery.of(context).size.width;
    Color backgroundColor = Theme.of(context).cardColor;

    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(ExtraColors.darkBlue),
        title: Text("Battery Inquiry"),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isProgressBarShown,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(
                height: 20,
              ),
              Row(
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
                        hint: Text("Select Make"),
                        isExpanded: true,
                        items: makeModelList.map((MakeModel value) {
                          return new DropdownMenuItem<String>(
                            value: value.name,
                            child: new Text(value.name),
                          );
                        }).toList(),
                        value: selectedMake,
                        onChanged: (value) {
                          getModelCode(value);

                          setState(() {
                            selectedMake = value;
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 40,
                    width: width * 0.45,

                    // margin: EdgeInsets.only(top: 15),
                    padding: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.3),
                        borderRadius: BorderRadius.circular(5)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: Text("Current Battery"),
                        isExpanded: true,
                        items: currentBatteryList.map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        value: selectCurrBattery,
                        onChanged: (value) {
                          setState(() {
                            selectCurrBattery = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
                    width: width * 0.45,
                    margin: EdgeInsets.only(top: 20),
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
                      controller: nameController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        isDense: true,
                        labelText: 'Name',
                        hintStyle: TextStyle(color: Color(0xffb8b8b8)),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              // SizedBox(
              //   height: 20,
              // ),
              Row(
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
                      controller: phoneController,
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

                    // padding: EdgeInsets.only(top: 10)                       ,
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
                      controller: emailController,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 40,
                    width: width * 0.45,
                    padding: EdgeInsets.only(left: 5),
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.3),
                        borderRadius: BorderRadius.circular(5)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: Text("Location"),
                        isExpanded: true,
                        items: locationList.map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        value: selectedLocation,
                        onChanged: (value) {
                          setState(() {
                            selectedLocation = value;
                          });
                        },
                      ),
                    ),
                  ),
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
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        _selectDate(context);
                      },
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      controller: dateController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        isDense: true,
                        labelText: 'Date',
                        hintStyle: TextStyle(color: Color(0xffb8b8b8)),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 60,
                    width: width * 0.45,

                    // margin: EdgeInsets.only(top: 10),
                    child: TextFormField(
                      validator: (value) {
                        if (value.length == 0) {
                          return ("Please fill up this field.");
                        } else {
                          return null;
                        }
                      },
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        _selectTime(context);
                      },
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      controller: timeController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        isDense: true,
                        labelText: 'Time',
                        hintStyle: TextStyle(color: Color(0xffb8b8b8)),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: width * 0.45,
                    padding: EdgeInsets.only(left: 5),
                    margin: EdgeInsets.only(bottom: 20),
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
                        value: selectedYear,
                        onChanged: (value) {
                          setState(() {
                            selectedYear = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              // SizedBox(
              //   height: 15,
              // ),
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
                  controller: commentController,
                  maxLines: 5,
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
                    color: Color(ExtraColors.darkBlue),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(5.0),
                      // side: BorderSide(color: Colors.black),
                    ),
                    onPressed: () {
                      // performLogin();
                      FocusScope.of(context).requestFocus(FocusNode());

                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        submitBatteryInquiryData();
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
              ),
              SizedBox(
                height: 30,
              ),
            ]),
          ),
        ),
      ),
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
              backgroundColor: Color(ExtraColors.darkBlue),
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
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        makeDate = picked.toString();
        dateController.text = makeDate.substring(0, 10);
      });
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    TimeOfDay t = await showTimePicker(
      context: context,
      initialTime: time,
    );
    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    if (t != null) {
      String formattedTime =
          localizations.formatTimeOfDay(time, alwaysUse24HourFormat: false);
      setState(() {
        timeController.text = formattedTime;
      });
    }
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

  Future<void> getInquiryDataForBatttery() async {
    Map<String, String> header = {
      "Content-Type": "application/json",
    };
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      showProgressBar();

      await http
          .get("https://fasttrackemarat.com/feed/battery.json", headers: header)
          .then((res) {
        hideProgressBar();
        int status = res.statusCode;
        if (status == Rcode.successCode) {
          var result = json.decode(res.body);

          var values = result['data'];
          setState(() {
            // makeList = List<String>.from(values['width']);
            locationList = List<String>.from(values['location']);
            currentBatteryList = List<String>.from(values['battery']);

            // heightList = List<String>.from(values['height']);
            // rimSizeList = List<String>.from(values['rim-size']);
            // brandList = List<String>.from(values['brand']);
          });
        }
      });
    } else {
      ShowToast.showToast(context, "No internet connection");
    }
  }

  void submitBatteryInquiryData() async {
    showProgressBar();

    Map<String, String> header = {
      "Content-Type": "application/json",
      "Accept": "application/json"
    };

    final body = jsonEncode({
      "car-brand": selectedMake,
      "car-model": selectedModel,
      "cbattery": selectCurrBattery,
      "year": selectedYear,
      "location": selectedLocation,
      "date": dateController.text,
      "time": timeController.text,
      "name": nameController.text,
      "email": emailController.text,
      "phone": phoneController.text,
      "message": commentController.text
    });
    await http
        .post("https://fasttrackemarat.com/contact-from-app/battery.php",
            headers: header, body: body)
        .then((res) {
      hideProgressBar();
      if (res.statusCode == Rcode.successCode) {
        displaySnackbar(context, "Inquiry submitted successfully");
        setState(() {
          timeController.text = "";
          dateController.text = "";
          commentController.text = "";
          selectedMake = null;
          selectedModel = null;
          selectedYear = null;
          selectedLocation = null;
        });
      } else {
        displaySnackbar(context, "Error: ${res.body}");
      }
    });
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

  Future<void> displaySnackbar(BuildContext context, msg) {
    final snackBar = SnackBar(
      content: Text('$msg'),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  getMakeList() async {
    Map<String, String> header = {
      "Content-Type": "application/json",
    };
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      showProgressBar();
      await http
          .get("https://fasttrackemarat.com/feed/make-model.json",
              headers: header)
          .then((res) {
        hideProgressBar();
        int status = res.statusCode;
        if (status == Rcode.successCode) {
          var result = json.decode(res.body);

          var values = result['data']["make"];

          makeModelList = values
              .map<MakeModel>((json) => MakeModel.fromJson(json))
              .toList();

          setState(() {});
        }
      });
    } else {
      ShowToast.showToast(context, "No internet connection");
    }
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

  Future<void> getPrefs() async {
    String customerName, customerNumber, customerEmail;

    setState(() {
      nearestStorePhn = SpUtil.getString(Constants.NEAREST_STORE_PHONENO)
          .replaceAll(new RegExp(r"\s+\b|\b\s"), "");
      whatsAppNum = SpUtil.getString(Constants.WHATS_APP_NUMBER);
      customerName = SpUtil.getString(Constants.CUSTOMER_NAME);
      customerNumber = SpUtil.getString(Constants.CUSTOMER_MOBILE_NO);
      customerEmail = SpUtil.getString(Constants.CUSTOMER_EMAIL);

      nameController.text = customerName;
      phoneController.text = customerNumber;
      emailController.text = customerEmail;
    });
  }
}
