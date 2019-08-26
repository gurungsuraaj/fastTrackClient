import 'package:fasttrackgarage_app/utils/AppBarWithTitle.dart';
import 'package:flutter/material.dart';
import 'package:fasttrackgarage_app/models/InventoryCheck.dart';

class InventoryCheckActivity extends StatefulWidget {
  @override
  _InventoryCheckActivityState createState() => _InventoryCheckActivityState();
}

class _InventoryCheckActivityState extends State<InventoryCheckActivity> {
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
                        obscureText: true,
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
                        child: Icon(Icons.search))
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
