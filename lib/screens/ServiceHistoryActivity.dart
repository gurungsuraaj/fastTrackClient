import 'dart:convert';

import 'package:charts_flutter/flutter.dart' as prefix1;
import 'package:fasttrackgarage_app/api/Api.dart';
import 'package:fasttrackgarage_app/models/ServiceHistoryItem.dart';
import 'package:fasttrackgarage_app/screens/ServiceHistoryPieChart.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:fasttrackgarage_app/utils/PrefsManager.dart';
import 'package:fasttrackgarage_app/utils/Rcode.dart';
import 'package:fasttrackgarage_app/utils/RoutesName.dart';
import 'package:fasttrackgarage_app/utils/Toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ServiceHistoryActivity extends StatefulWidget {
  @override
  _ServiceHistoryActivityState createState() => _ServiceHistoryActivityState();
}

class _ServiceHistoryActivityState extends State<ServiceHistoryActivity> {
  bool isProgressBarShown = false;

  String basicToken = "";
  List<ServiceHistoryItem> serviceHistoriesList =
      new List<ServiceHistoryItem>();

  @override
  void initState() {
    super.initState();

    PrefsManager.getBasicToken().then((token) {
      basicToken = token;
      getServiceHistoryList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
        fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black);
    return Scaffold(
        appBar: AppBar(
          title: Text("Service history"),
          backgroundColor: Color(ExtraColors.DARK_BLUE),
        ),
        body: ModalProgressHUD(
          inAsyncCall: isProgressBarShown,
          dismissible: false,
          child: ListView.builder(
            itemCount: serviceHistoriesList.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Text("Posting Date :", style: textStyle),
                              ),
                              Container(
                                child: Text(
                                  "Document no. :",
                                  style: textStyle,
                                ),
                              ),
                              Container(
                                child: Text(
                                  "Make :",
                                  style: textStyle,
                                ),
                              ),
                              Container(
                                child: Text(
                                  "Model :",
                                  style: textStyle,
                                ),
                              ),
                              Container(
                                child: Text(
                                  "Vehicle serial no. :",
                                  style: textStyle,
                                ),
                              ),
                              Container(
                                child: Text(
                                  "Location :",
                                  style: textStyle,
                                ),
                              ),
                              Container(
                                child: Text(
                                  "No. :",
                                  style: textStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 20, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                child: Text(
                                    serviceHistoriesList[index].Posting_Date,
                                    style: textStyle),
                              ),
                              Container(
                                child: Text(
                                  serviceHistoriesList[index].Document_No,
                                  style: textStyle,
                                ),
                              ),
                              Container(
                                child: Text(
                                  serviceHistoriesList[index].Make_Code,
                                  style: textStyle,
                                ),
                              ),
                              Container(
                                child: Text(
                                  serviceHistoriesList[index].Model_Code,
                                  style: textStyle,
                                ),
                              ),
                              Container(
                                child: Text(
                                  serviceHistoriesList[index].Vehicle_Serial_No,
                                  style: textStyle,
                                ),
                              ),
                              Container(
                                child: Text(
                                  serviceHistoriesList[index].Location_Code,
                                  style: textStyle,
                                ),
                              ),
                              Container(
                                child: Text(
                                  serviceHistoriesList[index].No,
                                  style: textStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  new Divider(
                    color: Colors.black,
                  ),
                ],
              );
            },
          ),
        ));
  }

  void getServiceHistoryList() async {
    showProgressBar();
    String url = Api.SERVICE_HISTORY_LIST;
    debugPrint("This is  url : $url");

    String customerNo = "CS000001";

    Map<String, String> body = {
      "Field": "Customer_No",
      "Criteria": customerNo,
    };

    var body_json = json.encode(body);

    Map<String, String> header = {
      "Content-Type": "application/json",
      
      "url":
          "DynamicsNAV/ws/FT%20Support/Page/ServiceLedger",
      "Authorization": "$basicToken"
    };

    await http.post(url, body: body_json, headers: header).then((res) {
      debugPrint("This is body: ${res.body}");
      int statusCode = res.statusCode;

      var data = json.decode(res.body);

      String message = data['message'];
      debugPrint(">>message $message");

      if (statusCode == Rcode.SUCCESS_CODE) {
        var values = data["data"] as List;
        debugPrint(">>>values $values");

        serviceHistoriesList = values
            .map<ServiceHistoryItem>(
                (json) => ServiceHistoryItem.fromJson(json))
            .toList();
        hideProgressBar();
      } else {
        ShowToast.showToast(context, message);
      }
    }).catchError((val) {
      debugPrint("error $val");
      ShowToast.showToast(context, "Something went wrong!");
      hideProgressBar();
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
}
