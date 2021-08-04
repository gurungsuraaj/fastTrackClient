import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ServiceHistoryPieChart extends StatefulWidget {
  final Widget child;

  ServiceHistoryPieChart({Key key, this.child}) : super(key: key);

  _ServiceHistoryPieChart createState() => _ServiceHistoryPieChart();
}

class _ServiceHistoryPieChart extends State<ServiceHistoryPieChart> {
  // List<charts.Series<Pollution, String>> _seriesData;
  List<charts.Series<Task, String>> _seriesPieData;
  // List<charts.Series<Sales, int>> _seriesLineData;

  _generateData() {
    var piedata = [
      new Task('Oil Exchanges', 35.8, Color(0xff3366cc)),
      new Task('Batteries', 8.3, Color(0xff990099)),
      new Task('Air filter', 10.8, Color(0xff109618)),
      new Task('Brakes', 15.6, Color(0xfffdbe19)),
      new Task('AC service', 19.2, Color(0xffff9900)),
      new Task('Other', 10.3, Color(0xffdc3912)),
    ];

    _seriesPieData.add(
      charts.Series(
        domainFn: (Task task, _) => task.task,
        measureFn: (Task task, _) => task.taskvalue,
        colorFn: (Task task, _) =>
            charts.ColorUtil.fromDartColor(task.colorval),
        id: 'Air Pollution',
        data: piedata,
        labelAccessorFn: (Task row, _) => '${row.taskvalue}',
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // _seriesData = List<charts.Series<Pollution, String>>();
    _seriesPieData = <charts.Series<Task, String>>[];
    // _seriesLineData = List<charts.Series<Sales, int>>();
    _generateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(ExtraColors.darkBlue),
        title: Text('Service Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: bodyData()),
                  ),
                ),
                Text(
                  'Spent on various services',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  child: charts.PieChart(_seriesPieData,
                      animate: true,
                      animationDuration: Duration(seconds: 1),
                      behaviors: [
                        new charts.DatumLegend(
                          outsideJustification:
                              charts.OutsideJustification.endDrawArea,
                          horizontalFirst: false,
                          desiredMaxRows: 2,
                          cellPadding:
                              new EdgeInsets.only(right: 4.0, bottom: 4.0),
                          entryTextStyle: charts.TextStyleSpec(
                              color: charts.MaterialPalette.purple.shadeDefault,
                              fontFamily: 'Georgia',
                              fontSize: 11),
                        )
                      ],
                      defaultRenderer: new charts.ArcRendererConfig(
                          arcWidth: 100,
                          arcRendererDecorators: [
                            new charts.ArcLabelDecorator(
                                labelPosition: charts.ArcLabelPosition.inside)
                          ])),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bodyData() => DataTable(
      onSelectAll: (b) {},
      sortColumnIndex: 1,
      sortAscending: true,
      columns: <DataColumn>[
        DataColumn(
          label: Text("Description"),
          numeric: false,
          onSort: (i, b) {
            setState(() {
              // _serviceDetailList.sort((a, b) => a.firstName.compareTo(b.firstName));
            });
          },
          tooltip: "To display first name of the Name",
        ),
        DataColumn(
          label: Text("Quantity"),
          numeric: false,
          onSort: (i, b) {
            setState(() {
              // _serviceDetailList.sort((a, b) => a.lastName.compareTo(b.lastName));
            });
          },
          tooltip: "To display last name of the Name",
        ),
        DataColumn(
          label: Text("Rate"),
          numeric: false,
          onSort: (i, b) {
            print("$i $b");
            setState(() {
              // _serviceDetailList.sort((a, b) => a.lastName.compareTo(b.lastName));
            });
          },
          tooltip: "To display last name of the Name",
        ),
        DataColumn(
          label: Text("Amount"),
          numeric: false,
          onSort: (i, b) {
            print("$i $b");
            setState(() {
              // _serviceDetailList.sort((a, b) => a.lastName.compareTo(b.lastName));
            });
          },
          tooltip: "To display last name of the Name",
        ),
      ],
      rows: _serviceDetailList
          .map(
            (item) => DataRow(
              cells: [
                DataCell(
                  Text(item.description),
                  showEditIcon: false,
                  placeholder: false,
                ),
                DataCell(
                  Text(item.quantity.toString()),
                  showEditIcon: false,
                  placeholder: false,
                ),
                DataCell(
                  Text(item.rate.toString()),
                  showEditIcon: false,
                  placeholder: false,
                ),
                DataCell(
                  Text(item.amount.toString()),
                  showEditIcon: false,
                  placeholder: false,
                )
              ],
            ),
          )
          .toList());
}

class Pollution {
  String place;
  int year;
  int quantity;

  Pollution(this.year, this.place, this.quantity);
}

class Task {
  String task;
  double taskvalue;
  Color colorval;

  Task(this.task, this.taskvalue, this.colorval);
}

class Sales {
  int yearval;
  int salesval;

  Sales(this.yearval, this.salesval);
}

class ServiceDetailsTableInfo {
  String description;
  int quantity;
  double rate;
  double amount;

  ServiceDetailsTableInfo(
      {this.description, this.quantity, this.rate, this.amount});
}

var _serviceDetailList = <ServiceDetailsTableInfo>[
  ServiceDetailsTableInfo(
      description: "Oil Change", quantity: 1, rate: 10.0, amount: 10.0),
  ServiceDetailsTableInfo(
      description: "Wash", quantity: 1, rate: 20.0, amount: 25.0),
  ServiceDetailsTableInfo(
      description: "Cockpit filter", quantity: 1, rate: 14.0, amount: 800.0),
  ServiceDetailsTableInfo(
      description: "Tyre", quantity: 1, rate: 11.0, amount: 25.0),
  ServiceDetailsTableInfo(
      description: "Oil Change", quantity: 1, rate: 25.0, amount: 10.0),
  ServiceDetailsTableInfo(
      description: "Wash", quantity: 1, rate: 400.0, amount: 880.0),
];
