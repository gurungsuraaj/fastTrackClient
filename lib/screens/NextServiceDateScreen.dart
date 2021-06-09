import 'package:fasttrackgarage_app/helper/NetworkOperationManager.dart';
import 'package:fasttrackgarage_app/helper/ntlmclient.dart';
import 'package:fasttrackgarage_app/models/NextServiceDateModel.dart';
import 'package:fasttrackgarage_app/models/VehicleListModel.dart';
import 'package:fasttrackgarage_app/utils/Constants.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:fasttrackgarage_app/utils/Rcode.dart';
import 'package:fasttrackgarage_app/utils/SPUtils.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ntlm/ntlm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class NextServiceDateScreen extends StatefulWidget {
  NextServiceDateScreen({Key key}) : super(key: key);

  @override
  _NextServiceDateScreenState createState() => _NextServiceDateScreenState();
}

class _NextServiceDateScreenState extends State<NextServiceDateScreen> {
  String customerNumber;
  bool isProgressBarShown = false;
  NTLMClient client;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<VehicleListModel> vehicleList = [];
  List<VehicleListModel> tempVehicleList = [];
  List<NextServiceDateModel> nextSerivceDateList = [];
  DateTime todayDate = DateTime.now();
  String serviceDateComment, lapseDateMessage;

  @override
  void initState() {
    super.initState();
    client =
        NTLM.initializeNTLM(Constants.NTLM_USERNAME, Constants.NTLM_PASSWORD);
    customerNumber = SpUtil.getString(Constants.CUSTOMER_NUMBER);
    getCompanyInfo().whenComplete(() {
      // getPrefs().whenComplete(() {
      getVehicleList();
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    var textStyle1 =
        TextStyle(color: Color(ExtraColors.DARK_BLUE), fontSize: 14);
    var textStyle2 = TextStyle(color: Color(0xffEF9C2B), fontSize: 14);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(ExtraColors.DARK_BLUE),
        title: Text("Next Service Date"),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isProgressBarShown,
        child: ListView.builder(
            itemCount: nextSerivceDateList.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  title: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: todayDate.isAfter(DateTime.parse(
                            nextSerivceDateList[index].nextServiceDate))
                        ? Wrap(children: [
                            Text(
                              '$lapseDateMessage for vehicle serial number ',
                            ),
                            Text(
                                '${nextSerivceDateList[index].vehicleSerialNo},',
                                style: textStyle2)
                          ])
                        : Wrap(children: <Widget>[
                            Text('Thank you for servicing your vehicle No.',
                                style: textStyle1),
                            Text("${nextSerivceDateList[index].registerNo}",
                                style: textStyle2),
                            Text(" at", style: textStyle1),
                            Text(
                                " Fasttrack-${nextSerivceDateList[index].locationName}",
                                style: textStyle2),
                            InkWell(
                              onTap: () async {
                                var url =
                                    "tel:${nextSerivceDateList[index].phoneNumber}";
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              child: Text(
                                  " ${nextSerivceDateList[index].phoneNumber}.",
                                  style: textStyle2),
                            ),
                            // Text(' As per our records', style: textStyle1),
                            Text(
                                "As per our records next service is due on ${nextSerivceDateList[index].nextServiceDate}.",
                                style: textStyle1)
                          ]),
                  ),

                  //  Text(
                  //     "Thank you for servicing your vehicle No.${nextSerivceDateList[index].registerNo} at Fasttrack-${nextSerivceDateList[index].locationName} ${nextSerivceDateList[index].phoneNumber}. As per our records next service is due on ${nextSerivceDateList[index].nextServiceDate}.",style: TextStyle(fontSize: 14),),

                  //      title: Text(
                  //     "Vehicle Reg. No :  ${nextSerivceDateList[index].registerNo}"),
                  // subtitle: Text(
                  //     "Next Service Date :     ${nextSerivceDateList[index].nextServiceDate}"),
                ),
              );
            }),
      ),
    );
  }

  // Future<void> getPrefs() async {
  //   customerNumber = SpUtil.getString(Constants.CUSTOMER_NUMBER);
  // }

  //to fetch the service date comment and lapse service message
  //from company informatoin API
  Future<void> getCompanyInfo() async {
    showProgressBar();
    NetworkOperationManager.getCompanyInfo(client).then((res) {
      hideProgressBar();
      if (res.length > 0) {
        serviceDateComment = res[0].serviceDateComment;
        lapseDateMessage = res[0].lapseServiceMessage;
      }
      print('the fetching of company information is successful');
    }).catchError((err) {
      hideProgressBar();
      showSnackBar(err);
    });
  }

  //to fetch the list of vehicles
  //if vehicles exists then call the service date API function
  //else call the functio to show the serviceDateComment in a pop up
  void getVehicleList() {
    showProgressBar();
    NetworkOperationManager.getVehicleList(customerNumber, client).then((res) {
      hideProgressBar();
      if (res.length > 0) {
        vehicleList = res;
        tempVehicleList = res;
        setState(() {});
        getNextServiceDate();
      } else {
        // showSnackBar('No Vehicle list available');
        showAlert(serviceDateComment);
        // getCompanyInfo();
      }
    }).catchError((err) {
      hideProgressBar();
      showSnackBar(err);
    });
  }

  //calling for the next service date for the first vehicle of vehicle list
  void getNextServiceDate() {
    getVehileDataFromNAV(
        tempVehicleList[0].Serial_No, tempVehicleList[0].Registration_No);
  }

  //fetching the next service date of the vehicle and adding it to nextSerivceDateList
  //then removes the first vehicle list from the vehicle list and
  //computes if the length of vehicle list is greate than zero
  //than recursively calls the getNextServiceDate() function 
  //else if next service date list is empty then shows dialogue box
  void getVehileDataFromNAV(String vehicleSerialNo, String regNo) {
    showProgressBar();
    NetworkOperationManager.checkServiceDate(
            customerNumber, vehicleSerialNo, regNo, client)
        .then((res) {
      print(res);
      if (res.status == Rcode.SUCCESS_CODE) {
        // NextServiceDateModel nextService = NextServiceDateModel();
        // nextService.vehicleSerialNo = vehicleSerialNo;
        // nextService.nextServiceDate = res.responseBody;
        // nextService.registerNo = regNo;
        print(" Date Status ${res.status}");
        nextSerivceDateList.add(res);
        setState(() {});
        tempVehicleList.removeAt(0);
        if (tempVehicleList.length > 0) {
          getNextServiceDate();
        } else {
          if (nextSerivceDateList.length == 0) {
            showAlert(serviceDateComment);
          }
        }
      } else {
        showSnackBar(res.faultString);
      }
      hideProgressBar();
    }).catchError((err) {
      hideProgressBar();
      print(err);
    });
  }

  showAlert(String message) {
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
            height: 150,
            child: Column(
              children: <Widget>[
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 35, 0, 20),
                        child: Text(message),
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

  showSnackBar(String snackString) {
    final snackBar = new SnackBar(
        content: Text(snackString),
        duration: Duration(minutes: 5),
        action: SnackBarAction(
          label: "OK",
          onPressed: () {
            _scaffoldKey.currentState.removeCurrentSnackBar();
          },
        ));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
