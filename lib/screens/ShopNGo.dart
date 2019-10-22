
import 'dart:convert';
import 'package:fasttrackgarage_app/screens/CartActivity.dart';
import 'package:fasttrackgarage_app/utils/AppBarWithTitle.dart';
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
                    searchItem();
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
                    itemCount: 5,
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
                                          "Castrol engine oil",
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(
                                          0, 16.0, 8.0, 16.0),
                                      child: Text(
                                        "AED 120",
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
      "http://202.166.211.230:7747/DynamicsNAV/ws/FT%20Support/Page/ItemList",
    };
    await http.post(url, body: body_json, headers: header).then((val) {
      debugPrint("came to response after post url..");
      debugPrint("This is status code: ${val.statusCode}");
      debugPrint("This is body: ${val.body}");
      int statusCode = val.statusCode;
      var result = json.decode(val.body);

      debugPrint("This is after result: $result");

      String message = result["message"];

      if(statusCode == Rcode.SUCCESS_CODE){
        hideProgressBar();
        ShowToast.showToast(context, message);
      }
      else {
        hideProgressBar();
        // display snackbar
      }
    }).catchError((val) {
      hideProgressBar();
      ShowToast.showToast(context, "Something went wrong!");
      //display snackbar
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
