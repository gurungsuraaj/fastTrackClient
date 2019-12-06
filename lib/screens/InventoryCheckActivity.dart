import 'dart:convert';
import 'package:custom_progress_dialog/custom_progress_dialog.dart';
import 'package:fasttrackgarage_app/api/Api.dart';
import 'package:fasttrackgarage_app/utils/AppBarWithTitle.dart';
import 'package:fasttrackgarage_app/utils/PrefsManager.dart';
import 'package:fasttrackgarage_app/utils/Rcode.dart';
import 'package:fasttrackgarage_app/utils/Toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:http/http.dart' as http;

class InventoryCheckActivity extends StatefulWidget {
  @override
  _InventoryCheckActivityState createState() => _InventoryCheckActivityState();
}

class _InventoryCheckActivityState extends State<InventoryCheckActivity> {

  TextEditingController detailsController = new TextEditingController();
  String basicToken = "";

  Widget bodyData() => DataTable(
      onSelectAll: (b) {},
      sortColumnIndex: 1,
      sortAscending: true,
      columns: <DataColumn>[
        DataColumn(
          label: Text("Item Description"),
          numeric: false,
          onSort: (i, b) {
            print("$i $b");
            setState(() {
              names.sort((a, b) => a.firstName.compareTo(b.firstName));
            });
          },
          tooltip: "To display first name of the Name",
        ),
        DataColumn(
          label: Text("Quantity In Stock"),
          numeric: false,
          onSort: (i, b) {
            print("$i $b");
            setState(() {
              names.sort((a, b) => a.lastName.compareTo(b.lastName));
            });
          },
          tooltip: "To display last name of the Name",
        ),
      ],
      rows: names
          .map(
            (name) => DataRow(
              cells: [
                DataCell(
                  Text(name.firstName),
                  showEditIcon: false,
                  placeholder: false,
                ),
                DataCell(
                  Text(name.lastName),
                  showEditIcon: false,
                  placeholder: false,
                )
              ],
            ),
          )
          .toList());

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Scaffold(
        appBar: AppBarWithTitle.getAppBar('Inventory Check'),
        body: Column(
          children: <Widget>[
            Container(
              height: 70,
              margin: EdgeInsets.fromLTRB(15, 15, 15, 10),
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width * 0.68,
                      height: 48,
                      child: TextField(
                        controller: detailsController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter Details',
                        ),
                      ),
                    ),
                    Container(
                        height: 37,
                        width: 44,
                        color: Colors.blue,
                        child: IconButton(
                          onPressed: () {
                            prepareToCheckInventory();
                          },
                            icon: Icon(Icons.search))),
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: bodyData(),
            ),
          ],
        ));
  }


  prepareToCheckInventory() async{

    PrefsManager.getBasicToken().then((token){
      basicToken = token;
      checkInventory();
    });
  }

  void checkInventory() async {
    String url = Api.POST_CHECKINVENTORY;

    String query = detailsController.text;
    prefix0.debugPrint("query : $query");

    debugPrint("This is  url : $url");

    String customerNo = "CS000001";

    Map<String, String> body = {
      "Field": "Customer_No",
      "Criteria": customerNo,
    };

    var body_json = json.encode(body);

    Map<String, String> header = {
      "Content-Type": "application/json",

      "url":
      "DynamicsNAV/ws/FT%20Support/Codeunit/CheckInventory",
      "Authorization": "$basicToken"
    };

    await http.post(url, body: body_json, headers: header).then((res) {
      debugPrint("This is body: ${res.body}");
      int statusCode = res.statusCode;

      var data = json.decode(res.body);

      String message = data['message'];
      debugPrint(">>message $message");

      if (statusCode == Rcode.SUCCESS_CODE) {
        var values = data["data"] as List;
        debugPrint(">>>values $values");

       /* serviceHistoriesList = values
            .map<ServiceHistoryItem>(
                (json) => ServiceHistoryItem.fromJson(json))
            .toList();*/

      } else {
        ShowToast.showToast(context, message);
      }
    }).catchError((val) {
      debugPrint("error $val");
      ShowToast.showToast(context, "Something went wrong!");

    });
  }

}

class Name {
  String firstName;
  String lastName;

  Name({this.firstName, this.lastName});
}

var names = <Name>[
  Name(firstName: "Battery", lastName: "6"),
  Name(firstName: "Fuse", lastName: "3"),
  Name(firstName: "Tyre", lastName: "8"),
];
