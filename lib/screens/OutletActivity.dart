import 'package:flutter/material.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'GoogleMap.dart';

class OutletActivity extends StatefulWidget {
  @override
  _OutletActivity createState() => _OutletActivity();
}

class _OutletActivity extends State<OutletActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Outlet"),
        backgroundColor: Color(ExtraColors.DARK_BLUE),
      ),
      body: Column(
        children: <Widget>[
          //\n  19 May 2019
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GoogleMapActivity()),
              );
            },
            child: ListTile(
              onTap: null,
              title: Container(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Text(
                  "Bur Dubai",
                  style: TextStyle(color: Color(ExtraColors.DARK_BLUE)),
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        "33,FastTrack Outlet,mankhod road",
                      )),
                  Text(
                    "Dubai",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                        color: Colors.grey),
                  )
                ],
              ),
              isThreeLine: true,
              trailing: Container(
                padding: EdgeInsets.only(top: 5),
                child: Icon(
                  Icons.location_on,
                  size: 55,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          new Divider(
            color: Colors.black,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GoogleMapActivity()),
              );
            },
            child: ListTile(
              onTap: null,
              title: Container(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Text(
                  "Bur Dubai",
                  style: TextStyle(color: Color(ExtraColors.DARK_BLUE)),
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        "33,FastTrack Outlet,mankhod road",
                      )),
                  Text(
                    "Dubai",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                        color: Colors.grey),
                  )
                ],
              ),
              isThreeLine: true,
              trailing: Container(
                padding: EdgeInsets.only(top: 5),
                child: Icon(
                  Icons.location_on,
                  size: 55,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          new Divider(
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
