import 'package:fasttrackgarage_app/helper/NetworkOperationManager.dart';
import 'package:fasttrackgarage_app/helper/ntlmclient.dart';
import 'package:fasttrackgarage_app/models/PostedSalesInvoiceModel.dart';
import 'package:fasttrackgarage_app/utils/Constants.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ntlm/ntlm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fasttrackgarage_app/utils/Rstring.dart';
import 'package:fasttrackgarage_app/utils/Toast.dart';

class PostedSalesInvoiceScreen extends StatefulWidget {
  @override
  _PostedSalesInvoiceScreenState createState() =>
      _PostedSalesInvoiceScreenState();
}

class _PostedSalesInvoiceScreenState extends State<PostedSalesInvoiceScreen> {
  NTLMClient client;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isProgressBarShown = false;
  String customerNumber = "";
  List<PostedSalesInvoiceModel> postedSalesList = List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    client =
        NTLM.initializeNTLM(Constants.NTLM_USERNAME, Constants.NTLM_PASSWORD);
    getPrefs().whenComplete(() {
      loadPostedSalesInvoiceData();
    });
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
        fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(ExtraColors.DARK_BLUE_ACCENT),
        title: Text("Check History"),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isProgressBarShown,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: postedSalesList.length,
            itemBuilder: (BuildContext context, int index) {
              PostedSalesInvoiceModel postedSaleInvoiceItem =
                  postedSalesList[index];
              return Card(
                elevation: 2,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Theme.of(context).accentColor,
                      height: 30,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "No : " + postedSaleInvoiceItem.no,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              sendMail(postedSaleInvoiceItem.no);
                            },
                            child: Row(
                              children: [
                                Text(
                                  'Send Email',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.mail,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // Container(
                                //   child: Text(
                                //     "No :",
                                //     style: TextStyle(
                                //         fontSize: 16.0,
                                //         fontWeight: FontWeight.bold),
                                //   ),
                                // ),
                                // SizedBox(
                                //   height: 5,
                                // ),
                                Container(
                                  child: Text("Customer Name :",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold)),
                                ),
                                // SizedBox(
                                //   height: 5,
                                // ),
                                // Container(
                                //   child: Text("Amount :",
                                //       style: TextStyle(
                                //           fontSize: 16.0,
                                //           fontWeight: FontWeight.bold)),
                                // ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  child: Text("Amt Inc. VAT :",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold)),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  child: Text("Location Name :",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold)),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  child: Text("Document Date :",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold)),
                                ),
                                // SizedBox(
                                //   height: 5,
                                // ),
                                // Container(
                                //   child: Text("Service Order :",
                                //       style: TextStyle(
                                //           fontSize: 16.0,
                                //           fontWeight: FontWeight.bold)),
                                // ),
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
                                // Container(
                                //   child: Text(postedSaleInvoiceItem.no,
                                //       style: textStyle),
                                // ),
                                // SizedBox(
                                //   height: 5,
                                // ),
                                Container(
                                  child: Text(
                                    postedSaleInvoiceItem.sellToCustomerName,
                                    style: textStyle,
                                  ),
                                ),
                                // SizedBox(
                                //   height: 5,
                                // ),
                                // Container(
                                //   child: Text(
                                //     postedSaleInvoiceItem.amt.toString(),
                                //     style: textStyle,
                                //   ),
                                // ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  child: Text(
                                    postedSaleInvoiceItem.amt_inc_VAT,
                                    style: textStyle,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  child: Text(
                                    postedSaleInvoiceItem.locationName,
                                    style: textStyle,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  child: Text(
                                    postedSaleInvoiceItem.documentDate,
                                    style: textStyle,
                                  ),
                                ),
                                // SizedBox(
                                //   height: 5,
                                // ),
                                // Container(
                                //   child: Text(
                                //     postedSaleInvoiceItem.serviceOrder,
                                //     style: textStyle,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // new Divider(
                    //   color: Colors.black,
                    // ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  void loadPostedSalesInvoiceData() async {
    showProgressBar();
    NetworkOperationManager.getPostedSalesInvoiceList(customerNumber, client)
        .then((res) {
      hideProgressBar();
      if (res.length > 0) {
        setState(() {
          postedSalesList = res;
        });
      } else {
        displaySnackbar(context, "Posted Invoice Sales List is empty");
      }
    }).catchError((e) {
      hideProgressBar();
      displaySnackbar(context, "Error : $e");
      print("this is error $e");
    });
  }

  void sendMail(String invoiceNo) async {
    showProgressBar();

    NetworkOperationManager.sendCheckHistoryEmail(invoiceNo, client)
        .then((res) {
      hideProgressBar();
      if (res.status == 200) {
        ShowToast.showToast(context, "${res.responseBody}");
      } else {
        ShowToast.showToast(context, "Error :" + "${res.responseBody}");
      }
    }).catchError((e) {
      hideProgressBar();
      print(e);
    });
  }

  Future<void> displaySnackbar(BuildContext context, msg) {
    final snackBar = SnackBar(
      content: Text('$msg'),
      duration: const Duration(seconds: 2),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
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

  Future<void> getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customerNumber = await prefs.getString(Constants.CUSTOMER_NUMBER);
  }
}
