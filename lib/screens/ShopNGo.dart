
import 'dart:convert';
import 'package:fasttrackgarage_app/models/Item.dart';
import 'package:fasttrackgarage_app/screens/CartActivity.dart';
import 'package:fasttrackgarage_app/utils/AppBarWithTitle.dart';
import 'package:fasttrackgarage_app/utils/PrefsManager.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;

import '../api/Api.dart';
import '../utils/Rcode.dart';
import '../utils/Toast.dart';


class ShopAndGo extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ShopAndGo();
  }

}

class _ShopAndGo extends State<ShopAndGo> {
  bool isProgressBarShown = false;
  TextEditingController searchController = new TextEditingController();

  List<Item> itemList = new List<Item>();

  String basicToken = "";


  @override
  void initState() {
    super.initState();

    PrefsManager.getBasicToken().then((token){
      basicToken = token;
    });

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
     appBar: AppBarWithTitle.getAppBar('Shop N Go'),
      body: ModalProgressHUD(
        inAsyncCall: isProgressBarShown,
        dismissible: false,
        child: Container(
          // padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
          margin: EdgeInsets.fromLTRB(18, 10, 18, 0),
          child: Column(
            children: <Widget>[

              TextField(
                controller: searchController,
                decoration: InputDecoration(labelText: 'Search'),
                onChanged: (text) {},
              ),

              Container(
                margin : EdgeInsets.only(top:7),

                child: RaisedButton(
                  onPressed: () {
                    if(searchController.text.isNotEmpty){
                      searchItem();
                    }
                  },
                  textColor: Colors.blue,
                  color: Colors.white,
                  child: new Text(
                    "SEARCH",
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: itemList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CartActivity()),
                          );
                        },
                        child: Card(
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.fromLTRB(
                                            8.0, 16.0, 0, 16.0),
                                        child: Text(
                                          itemList[index].Description,
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(
                                          0, 16.0, 8.0, 16.0),
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
        ),
      ),

    );
  }

  void searchItem() async {
    FocusScope.of(context).requestFocus(FocusNode());

    showProgressBar();
    String url = Api.SEARCH_ITEM;
    debugPrint("This is  url : $url");

    String itemNumber = searchController.text;


    Map<String, String> body = {
      "No": itemNumber,
    };

    var body_json = json.encode(body);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "username": "PSS",
      "password": "\$ky\$p0rt\$",
      "url":
      "http://desktop-oqceko4:7747/DynamicsNAV/ws/FT%20Support/Page/ItemList",
      "Authorization": "$basicToken"
    };

    await http.post(url, body: body_json, headers: header).then((res) {
      debugPrint("This is body: ${res.body}");
      int statusCode = res.statusCode;

      var data = json.decode(res.body);

      String message = data['message'];
      debugPrint(">>message $message");

      if(statusCode == Rcode.SUCCESS_CODE){
        hideProgressBar();

        var values = data["data"] as List;
        debugPrint(">>>values $values");

        itemList = values.map<Item>((json) => Item.fromJson(json)).toList();
      }
      else {
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

}
