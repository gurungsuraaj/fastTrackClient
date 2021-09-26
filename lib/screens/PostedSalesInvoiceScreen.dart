import 'package:connectivity/connectivity.dart';
import 'package:fasttrackgarage_app/helper/NetworkOperationManager.dart';
import 'package:fasttrackgarage_app/helper/ntlmclient.dart';
import 'package:fasttrackgarage_app/models/PostedSalesInvoiceModel.dart';
import 'package:fasttrackgarage_app/utils/Constants.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:fasttrackgarage_app/utils/SPUtils.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ntlm/ntlm.dart';
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
  List<PostedSalesInvoiceModel> postedSalesList = [];
  @override
  void initState() {
    super.initState();
    client =
        NTLM.initializeNTLM(Constants.ntlmUsername, Constants.ntlmPassword);
    getPrefs().whenComplete(() {
      loadPostedSalesInvoiceData();
    });
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    );
    return Scaffold(
      backgroundColor: Color(ExtraColors.scaffoldColor),

      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(ExtraColors.appBarColor),
        title: Text("CHECK HISTORY", style: TextStyle(fontStyle: FontStyle.italic)),
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
                elevation: 0,
                color: Color(ExtraColors.scaffoldColor),
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
                                          color: Colors.white,
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
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  child: Text("Location Name :",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  child: Text("Document Date :",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.white,
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
                                    postedSaleInvoiceItem.amtIncVat,
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

                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: new Divider(
                        color: Color(0xffef773c),
                        thickness:1.0,
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  void loadPostedSalesInvoiceData() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
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
    } else {
      ShowToast.showToast(context, "No internet connection");
    }
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

  displaySnackbar(BuildContext context, msg) {
    final snackBar = SnackBar(
      content: Text('$msg'),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
    customerNumber = SpUtil.getString(Constants.customerNo);
  }
}
