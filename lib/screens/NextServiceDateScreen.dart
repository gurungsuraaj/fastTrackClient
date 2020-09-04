import 'package:fasttrackgarage_app/helper/NetworkOperationManager.dart';
import 'package:fasttrackgarage_app/helper/ntlmclient.dart';
import 'package:fasttrackgarage_app/models/NextServiceDateModel.dart';
import 'package:fasttrackgarage_app/models/VehicleListModel.dart';
import 'package:fasttrackgarage_app/utils/Constants.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:fasttrackgarage_app/utils/Rcode.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ntlm/ntlm.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List<VehicleListModel> vehicleList = List();
  List<NextServiceDateModel> nextSerivceDateList = List();

  @override
  void initState() {
    super.initState();
    client =
        NTLM.initializeNTLM(Constants.NTLM_USERNAME, Constants.NTLM_PASSWORD);
    getPrefs().whenComplete(() {
      getVehicleList().whenComplete(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(ExtraColors.DARK_BLUE),
        title: Text("Next Serivce Date"),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isProgressBarShown,
        child: ListView.builder(
            itemCount: nextSerivceDateList.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  title: Text(
                      "Vehicle Serial No :  ${nextSerivceDateList[index].vehicleSerialNo}"),
                  subtitle: Text(
                      "Next Serivce Date :     ${nextSerivceDateList[index].nextServiceDate}"),
                ),
              );
            }),
      ),
    );
  }

  Future<void> getVehicleList() async {
    showProgressBar();
    NetworkOperationManager.getVehicleList(customerNumber, client).then((res) {
      hideProgressBar();
      if (res.length > 0) {
        print("Inside success ${res.length}");
        vehicleList = res;
        setState(() {});
        getNextServiceDate();
      } else {
        showSnackBar('No Vehicle list available');
      }
    }).catchError((err) {
      hideProgressBar();
      showSnackBar(err);
    });
  }

  Future<void> getPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    customerNumber = await prefs.getString(Constants.CUSTOMER_NUMBER);
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
    print(snackString);
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

  void getNextServiceDate() async {
    for (VehicleListModel vehicle in vehicleList) {
      getVehileDataFromNAV(vehicle.Serial_No);
    }
  }

  void getVehileDataFromNAV(String vehicleSerialNo) async {
    showProgressBar();
    NetworkOperationManager.checkServiceDate(
            customerNumber, vehicleSerialNo, client)
        .then((res) {
      print(res.responseBody);
      if (res.status == Rcode.SUCCESS_CODE) {
        NextServiceDateModel nextService = NextServiceDateModel();
        nextService.vehicleSerialNo = vehicleSerialNo;
        nextService.nextServiceDate = res.responseBody;
        nextSerivceDateList.add(nextService);
        setState(() {});
      } else {
        // showSnackBar(res.responseBody);
      }
      hideProgressBar();
    }).catchError((err) {
      hideProgressBar();
      print(err);
    });
  }
}
