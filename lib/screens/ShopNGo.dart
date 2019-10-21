import 'package:fasttrackgarage_app/screens/CartActivity.dart';
import 'package:fasttrackgarage_app/utils/AppBarWithTitle.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

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
                decoration: InputDecoration(labelText: 'Search'),
                onChanged: (text) {},
              ),

              Container(
                margin : EdgeInsets.only(top:7),

                child: RaisedButton(
                  onPressed: () {
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

}
