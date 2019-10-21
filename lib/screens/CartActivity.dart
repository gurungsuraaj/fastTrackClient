import 'package:fasttrackgarage_app/utils/AppBarWithTitle.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:flutter/material.dart';

class CartActivity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CartActivity();
  }
}

class _CartActivity extends State<CartActivity> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBarWithTitle.getAppBar('Cart Manager'),
      body: Column(
        children: <Widget>[
          Card(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(8.0, 16.0, 0, 16.0),
                          child: Text(
                            "Castrol engine oil",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 16.0, 8.0, 16.0),
                        child: Text(
                          "AED 120",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: RaisedButton(
                          onPressed: () {},
                          textColor: Colors.black,
                          color: Colors.white,
                          child: new Text(
                            " - ",
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      Text(
                        "  1  ",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: RaisedButton(
                          onPressed: () {},
                          textColor: Colors.black,
                          color: Colors.white,
                          child: new Text(
                            " + ",
                          ),
                        ),
                      ),
                  SizedBox(width: 100.0,),
                  Text(
                  "Total: AED 120",
                  style: TextStyle(fontSize: 16.0, color: Colors.redAccent),
                ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Card(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(8.0, 16.0, 0, 16.0),
                          child: Text(
                            "Wires",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 16.0, 8.0, 16.0),
                        child: Text(
                          "AED 10",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: RaisedButton(
                          onPressed: () {},
                          textColor: Colors.black,
                          color: Colors.white,
                          child: new Text(
                            " - ",
                          ),
                        ),
                      ),
                      Text(
                        "  2  ",
                      ),

                        SizedBox(
                          height: 50,
                          width: 50,
                          child: RaisedButton(
                            onPressed: () {},
                            textColor: Colors.black,
                            color: Colors.white,
                            child: new Text(
                              " + ",
                            ),
                          ),
                        ),


                      SizedBox(width: 100.0,),
                      Text(
                        "Total: AED 20",
                        style: TextStyle(fontSize: 16.0, color: Colors.redAccent),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          SizedBox(height: 290,),
          Container(
            margin: EdgeInsets.all(16.0),
            width: MediaQuery.of(context).size.width,
            child: RaisedButton(
              color: Color(ExtraColors.DARK_BLUE),
              onPressed: () {
              },
              child: Text(
                "Make payment",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
