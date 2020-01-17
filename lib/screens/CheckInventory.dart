import 'dart:convert';
import 'dart:async';

import 'package:custom_progress_dialog/custom_progress_dialog.dart';
import 'package:fasttrackgarage_app/api/Api.dart';
import 'package:fasttrackgarage_app/helper/NetworkOperationManager.dart';
import 'package:fasttrackgarage_app/helper/ntlmclient.dart';
import 'package:fasttrackgarage_app/models/Item.dart';
import 'package:fasttrackgarage_app/models/NetworkResponse.dart';
import 'package:fasttrackgarage_app/models/OutletList.dart';
import 'package:fasttrackgarage_app/models/SearchItem.dart';
import 'package:fasttrackgarage_app/utils/AppBarWithTitle.dart';
import 'package:fasttrackgarage_app/utils/Constants.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:fasttrackgarage_app/utils/PrefsManager.dart';
import 'package:fasttrackgarage_app/utils/Rcode.dart';
import 'package:fasttrackgarage_app/utils/Toast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:ntlm/ntlm.dart';
import 'package:xml2json/xml2json.dart';
import 'package:xml/xml.dart' as xml;
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class CheckInventory extends StatefulWidget {
  @override
  _CheckInventoryState createState() => _CheckInventoryState();
}

class _CheckInventoryState extends State<CheckInventory> {
  String dropdownValue1 = "One";
  String dropdownValue2 = "One";
  String search;
  NTLMClient client;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Item> itemList = new List<Item>();
  List<OutletList> outletList = new List<OutletList>();
  OutletList selectedValue = new OutletList();
  List<DropdownMenuItem<OutletList>> _outletList =
      new List<DropdownMenuItem<OutletList>>();
  List<Item> item = new List<Item>();
  Item selectItemValue = new Item();
  List<DropdownMenuItem<Item>> _itemList = new List();

  TextEditingController detailsController = new TextEditingController();
  String basicToken = "";

  bool isProgressBarShown = false;
  ProgressDialog _progressDialog = ProgressDialog();
  TextEditingController searchController = new TextEditingController();
  List<TextEditingController> textEditContollerlist = new List();
  List<SearchItemModel> searchList = new List();

  //List<String> value = new List<String>();

  @override
  void initState() {
    super.initState();
    client =
        NTLM.initializeNTLM(Constants.NTLM_USERNAME, Constants.NTLM_PASSWORD);
    PrefsManager.getBasicToken().then((token) {
      basicToken = token;
      prepareToCheckInventory("", client).then((onValue) {
        getOutletList().then((outletList) {
          setState(() {
            _outletList = buildOutletDropdownMenu(outletList);
            selectedValue = _outletList[0].value;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(ExtraColors.DARK_BLUE),
        actions: <Widget>[
          IconButton(
              icon: Icon(FontAwesomeIcons.barcode),
              onPressed: () {
                _scanQR();
              })
        ],
      ),
      body: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(16, 8, 16, 0),
                height: MediaQuery.of(context).size.height / 13,
                child: DropdownButton(
                    isExpanded: true,
                    value: selectedValue,
                    items: _outletList,
                    onChanged: onChangeOutletDropdown),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 2, 16, 0),
                height: MediaQuery.of(context).size.height / 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height / 13,
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          labelText: 'Enter Details',
                        ),
                        onSubmitted: (val) {
                          prepareToCheckInventory(val, client);
                        },
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 15,
                      width: MediaQuery.of(context).size.width / 9,
                      alignment: Alignment.center,
                      child: Center(
                        widthFactor: 10,
                        heightFactor: 10,
                        child: IconButton(
                          onPressed: () {
                            prepareToCheckInventory(
                                searchController.text, client);
                          },
                          icon: Center(
                            child: Icon(Icons.search),
                          ),
                          iconSize: 35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: searchList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      /*Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CartActivity()),
                      ); */
                    },
                    child: Card(
                      color: Colors.white,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(8.0, 8.0, 0, 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  searchList[index].description,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Car: " + searchList[index].makeCode,
                                      style: TextStyle(
                                          fontSize: 13.0, color: Colors.grey),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Model: " + searchList[index].modelCode,
                                      style: TextStyle(
                                          fontSize: 13.0, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Container(
                            //   padding:
                            //       EdgeInsets.fromLTRB(0, 16.0, 8.0, 16.0),
                            //   child: Text(
                            //     searchList[index].Unit_Price,
                            //     style: TextStyle(fontSize: 16.0),
                            //   ),
                            // ),
                            Container(
                                padding:
                                    EdgeInsets.fromLTRB(0, 16.0, 8.0, 16.0),
                                child:
                                    (double.parse(searchList[index].inventory) >
                                            0)
                                        ? Text("Stock available",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.green))
                                        : Text("Stock not available",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.red)))
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<List<OutletList>> getOutletList() async {
    String url = Api.LOCCATION_LIST;
    debugPrint("---url---$url");

    Map<String, String> body = {"Key": "", "Code": "", "Name": ""};
    var body_json = json.encode(body);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "url": "DynamicsNAV/ws/FT%20Support/Page/LocationList",
      "Authorization": "$basicToken"
    };

    await http.post(url, body: body_json, headers: header).then((res) {
      debugPrint("this is status code ${res.statusCode}");
      var result = json.decode(res.body);
      var values = result['data'] as List;

      if (res.statusCode == Rcode.SUCCESS_CODE) {
        outletList = values
            .map<OutletList>((json) => OutletList.fromJson(json))
            .toList();
      }
    }).catchError((onError) {
      debugPrint("$onError");
    });

    return outletList;
  }

  List<DropdownMenuItem<OutletList>> buildOutletDropdownMenu(List outlet) {
    List<DropdownMenuItem<OutletList>> outletData = List();
    for (OutletList outletList in outlet) {
      outletData.add(DropdownMenuItem(
        value: outletList,
        child: Text(outletList.Name),
      ));
    }

    return outletData;
  }

  List<DropdownMenuItem<Item>> buildItemDropdownMenu(List item) {
    List<DropdownMenuItem<Item>> itemData = List();
    for (Item itemList in item) {
      itemData.add(DropdownMenuItem(
        value: itemList,
        child: Text(itemList.Description),
      ));
    }

    return itemData;
  }

  Future<List<Item>> searchItem() async {
    //FocusScope.of(context).requestFocus(FocusNode());

    showProgressDialog(context);
    String url = Api.ITEMLIST;
    debugPrint("This is  url : $url");

    //String itemNumber = searchController.text;

    Map<String, String> body = {"Key": "", "Code": "", "Name": "Condensor"};

    var body_json = json.encode(body);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "url": "DynamicsNAV/ws/FT%20Support/Page/ItemList",
      "Authorization": "$basicToken"
    };

    debugPrint("Token $basicToken");

    await http.post(url, body: body_json, headers: header).then((res) {
      debugPrint("This is body: ${res.body}");
      int statusCode = res.statusCode;

      var data = json.decode(res.body);

      String message = data['message'];
      debugPrint(">>message $message");

      if (statusCode == Rcode.SUCCESS_CODE) {
        hideProgressDialog(context);

        var values = data["data"] as List;
        debugPrint(">>>values $values");

        itemList = values.map<Item>((json) => Item.fromJson(json)).toList();
      } else {
        hideProgressDialog(context);
        ShowToast.showToast(context, message);
      }
    }).catchError((val) {
      hideProgressDialog(context);
      debugPrint("error $val");
      ShowToast.showToast(context, "Something went wrong!");
    });

    return itemList;
  }

  void showProgressDialog(BuildContext context) {
    _progressDialog.showProgressDialog(context,
        textToBeDisplayed: 'Please wait...');
  }

  void hideProgressDialog(BuildContext context) {
    _progressDialog.dismissProgressDialog(context);
  }

  void onChangeOutletDropdown(OutletList value) {
    setState(() {
      selectedValue = value;
    });
  }

  void onChangeItemDropdown(Item value) {
    setState(() {
      selectItemValue = value;
    });
  }

  Future prepareToCheckInventory(String search, NTLMClient client) async {
    showProgressDialog(context);
    NetworkOperationManager.searchItemFromNav(search, client).then((val) {
      debugPrint("This is the response $val");
      if (val.length <= 0) {
        ShowToast.showToast(context, "No such product found !!");
      } else {
        setState(() {
          searchList = val;
        });
      }

      hideProgressDialog(context);
    }).catchError((err) {
      print("There is an error: $err");
    });
  }

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        searchController.text = qrResult;

        getItemFromBarcode();
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        displaySnackbar(context, "Camera permission was denied");
      } else {
        displaySnackbar(context, "Unknown Error $ex");
      }
    } on FormatException {
      displaySnackbar(
          context, "You pressed the back button before scanning anything");
    } catch (ex) {
      displaySnackbar(context, "Unknown Error $ex");
    }
  }

  void displaySnackbar(BuildContext context, msg) {
    final snackBar = SnackBar(
      content: Text('$msg'),
      duration: const Duration(seconds: 2),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void getItemFromBarcode() async {
    showProgressDialog(context);
    await NetworkOperationManager.getItemFromBarcodeScanning(
            searchController.text, client)
        .then((res) {
          hideProgressDialog(context);
      if (res.length <= 0) {
        ShowToast.showToast(context, "No such product found !!");
      } else {
        setState(() {
          searchList = res;
        });
      }
    }).catchError((err) {
      hideProgressDialog(context);
      ShowToast.showToast(context, "Error : $err !!");
    });
  }
}
