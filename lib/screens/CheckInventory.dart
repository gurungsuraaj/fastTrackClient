import 'dart:convert';

import 'package:fasttrackgarage_app/api/Api.dart';
import 'package:fasttrackgarage_app/models/Item.dart';
import 'package:fasttrackgarage_app/models/OutletList.dart';
import 'package:fasttrackgarage_app/utils/AppBarWithTitle.dart';
import 'package:fasttrackgarage_app/utils/PrefsManager.dart';
import 'package:fasttrackgarage_app/utils/Rcode.dart';
import 'package:fasttrackgarage_app/utils/Toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CheckInventory extends StatefulWidget {
  @override
  _CheckInventoryState createState() => _CheckInventoryState();
}

class _CheckInventoryState extends State<CheckInventory> {
  String dropdownValue1 = "One";
  String dropdownValue2 = "One";
  List<Item> itemList = new List<Item>();
  List<OutletList> outletList = new List<OutletList>();
  OutletList selectedValue = new OutletList();
  List<DropdownMenuItem<OutletList>> _outletList =
      new List<DropdownMenuItem<OutletList>>();
  String basicToken = "";

  bool isProgressBarShown = false;

  //List<String> value = new List<String>();

  @override
  void initState() {
    super.initState();

    PrefsManager.getBasicToken().then((token) {
      basicToken = token;

      searchItem();
      getOutletList().then((outletList) {
        setState(() {
          _outletList = buildOutletDropdownMenu(outletList);
          selectedValue = _outletList[0].value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBarWithTitle.getAppBar('Inventory Check'),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(16, 8, 0, 0),
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 13,
                child: DropdownButton(
                    isExpanded: true,
                    value: selectedValue,
                    items: _outletList,
                    onChanged: onChangeOutletDropdown),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 13,
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: dropdownValue2,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue2 = newValue;
                    });
                  },
                  items: <String>['One', 'Two', 'Three', 'Four']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: itemList.length,
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
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    padding:
                                        EdgeInsets.fromLTRB(8.0, 16.0, 0, 16.0),
                                    child: Text(
                                      itemList[index].Description,
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.fromLTRB(0, 16.0, 8.0, 16.0),
                                  child: Text(
                                    itemList[index].Unit_Price,
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
    showProgressBar();
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
      hideProgressBar();
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

  void searchItem() async {
    //FocusScope.of(context).requestFocus(FocusNode());

    showProgressBar();
    String url = Api.ITEMLIST;
    debugPrint("This is  url : $url");

    //String itemNumber = searchController.text;

    Map<String, String> body = {"Key": "", "Code": "", "Name": ""};

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
        hideProgressBar();

        var values = data["data"] as List;
        debugPrint(">>>values $values");

        itemList = values.map<Item>((json) => Item.fromJson(json)).toList();
      } else {
        hideProgressBar();
        ShowToast.showToast(context, message);
      }
    }).catchError((val) {
      hideProgressBar();
      debugPrint("error $val");
      ShowToast.showToast(context, "Something went wrong!");
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

  void onChangeOutletDropdown(OutletList value) {
    setState(() {
      selectedValue = value;
    });
  }
}
