import 'package:fasttrackgarage_app/screens/HomeActivity.dart';
import 'package:fasttrackgarage_app/utils/ReusableAppBar.dart';
import 'package:fasttrackgarage_app/utils/RoutesName.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:pinput/pin_put/pin_put.dart';

class OTP extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _OTP();
  }
}

class _OTP extends State<OTP> {
  @override
  Widget build(BuildContext context) {
    var _scaffoldKey = new GlobalKey<ScaffoldState>();
    bool isProgressBarShown = false;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    double MARGIN = 24.0;
    double PADDING = 10.0;

    TextEditingController controller = TextEditingController();

    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Builder(
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ReusableAppBar.getAppBar(0, PADDING, height, width),
              //Container
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Container(
                          margin: EdgeInsets.only(top: MARGIN),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'ENTER OTP',
                                style: TextStyle(
                                    color: Colors.blue[800], fontSize: 25),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 35, top: 10),
                                child: Text(
                                  'Please enter the OTP to proceed',
                                  style: TextStyle(
                                      color: Colors.grey
                                  ),
                                ),
                              ),
                              Center(
                                child: PinPut(
                                  autoFocus: false,
                                  actionButtonsEnabled: true,
                                  clearInput: true,
                                  fieldsCount: 4,
                                  onClear: (String pin) {
                                    debugPrint('$pin');
                                    setState(() {
                                      pin = '';
                                    });
                                  },
                                  onSubmit: (String pin) {
                                    //_showSnackBar(pin, context);
                                    Navigator.pushNamed(
                                        context, RoutesName.HOME_ACTIVITY);
                                  },
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String pin, BuildContext context) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 5),
      content: Container(
          height: 80.0,
          child: Center(
            child: Text(
              'Pin Submitted. Value: $pin',
              style: TextStyle(fontSize: 25.0),
            ),
          )),
      backgroundColor: Colors.greenAccent,
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
