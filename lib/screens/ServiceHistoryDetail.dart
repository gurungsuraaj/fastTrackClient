import 'package:fasttrackgarage_app/models/ServiceHistoryItem.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:flutter/material.dart';

class ServiceHistoryDetail extends StatefulWidget {
  final ServiceHistoryItem serviceHistoryItem;
  ServiceHistoryDetail(this.serviceHistoryItem);
  @override
  _ServiceHistoryDetailState createState() => _ServiceHistoryDetailState();
}

class _ServiceHistoryDetailState extends State<ServiceHistoryDetail> {
  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
        fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black);
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
         centerTitle: true,
        title: Text(
          "Service History Detail",
        ),
        backgroundColor: Color(ExtraColors.darkBlue),
      ),
      backgroundColor: Color(0xFFD9D9D9),
      body: Container(
        height: height / 1.7,
        padding: EdgeInsets.fromLTRB(2, 8, 8, 8),
        child: Card(
          elevation: 2,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(16, 10, 0, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "Posting Date :",
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text("Document no. :",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text("Make :",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text("Model :",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text("Vehicle serial no. :",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text("Location :",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text("No. :",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text("Entry Type :",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text("VIN :",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text("User Id :",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text("Customer Id :",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text("Description :",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text("Quantity :",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text("Unit Price :",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text("Total Amount :",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 20, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            child: Text(widget.serviceHistoryItem.postingDate,
                                style: textStyle),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text(
                              widget.serviceHistoryItem.documentNo,
                              style: textStyle,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text(
                              widget.serviceHistoryItem.makeCode,
                              style: textStyle,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text(
                              widget.serviceHistoryItem.modelCode,
                              style: textStyle,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text(
                              widget.serviceHistoryItem.vehicleSerialNo,
                              style: textStyle,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text(
                              widget.serviceHistoryItem.locationCode,
                              style: textStyle,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text(
                              widget.serviceHistoryItem.no,
                              style: textStyle,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text(
                              widget.serviceHistoryItem.entryType,
                              style: textStyle,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text(
                              widget.serviceHistoryItem.vin,
                              style: textStyle,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text(
                              widget.serviceHistoryItem.userId,
                              style: textStyle,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text(
                              widget.serviceHistoryItem.customerId,
                              style: textStyle,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text(
                              widget.serviceHistoryItem.description,
                              style: textStyle,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text(
                              widget.serviceHistoryItem.quantity.toString(),
                              style: textStyle,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text(
                              widget.serviceHistoryItem.unitPrice.toString(),
                              style: textStyle,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text(
                              widget.serviceHistoryItem.totalAmount.toString(),
                              style: textStyle,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // new Divider(
              //   color: Colors.black,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
