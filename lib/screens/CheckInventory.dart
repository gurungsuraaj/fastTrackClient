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
  List<Item> item = new List<Item>();
  Item selectItemValue = new Item();
  List<DropdownMenuItem<Item>> _itemList = new List();

  TextEditingController detailsController = new TextEditingController();
  String basicToken = "";

  bool isProgressBarShown = false;

  //List<String> value = new List<String>();

  @override
  void initState() {
    super.initState();

    PrefsManager.getBasicToken().then((token) {
      basicToken = token;

      searchItem().then((itemList) {
        setState(() {
          _itemList = buildItemDropdownMenu(itemList);
          selectItemValue = _itemList[0].value;
        });
      });

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
                      height: MediaQuery.of(context).size.height / 15,
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextField(
                        controller: detailsController,
                        decoration: InputDecoration(
                          labelText: 'Enter Details',
                        ),
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
                            prepareToCheckInventory();
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

    return itemList;
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

  void onChangeItemDropdown(Item value) {
    setState(() {
      selectItemValue = value;
    });
  }

  void prepareToCheckInventory() {}
}
