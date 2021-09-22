import 'package:fasttrackgarage_app/models/ServiceModel.dart';
import 'package:fasttrackgarage_app/screens/ServiceDetailActivity.dart';
import 'package:fasttrackgarage_app/utils/AppBarWithTitle.dart';
import 'package:fasttrackgarage_app/utils/Rcode.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:modal_progress_hud/modal_progress_hud.dart';

class ServiceActivity extends StatefulWidget {
  @override
  _ServiceActivityState createState() => _ServiceActivityState();
}

class _ServiceActivityState extends State<ServiceActivity>
    with TickerProviderStateMixin {
  var textDecoration = TextDecoration.underline;
  var fontSize = 18.0;
  var imageWidth = 35.0;
  var imageHeight = 35.0;
  var checkBoxVal = false;
  var checkboxVal2 = false;
  var checkboxVal3 = false;
  var listHeight = 170.0;
  List serviceList = [];
  bool isProgressBarShown = false;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
//    getServiceList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xff05135b),
        title: Text("SERVICES", style: TextStyle(fontStyle: FontStyle.italic)),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isProgressBarShown,
        child: Container(
          child:

//          new GridView.count(
//              physics: NeverScrollableScrollPhysics(),
//              shrinkWrap: true,
//              crossAxisCount: 2,
//              childAspectRatio: 1,
//              padding: const EdgeInsets.all(15.0),
//              mainAxisSpacing: 10.0,
//              crossAxisSpacing: 4.0,
//              children: <Widget>[
//                Card(
//                    child: Container(
//                        child: InkWell(
//                            onTap: () {
//                              Navigator.push(
//                                context,
//                                MaterialPageRoute(
//                                    builder: (context) =>
//                                        ServiceDetailActivity("Air Conditioning")),
//                              );
//                            },
//                            child: Column(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              crossAxisAlignment:
//                              CrossAxisAlignment.center,
//                              children: <Widget>[
//                                Image.asset(
//                                  "images/air-conditioning.png",
//                                  height: 70,
//                                  width: 50,
//                                ),
//                                Container(
//                                    padding: EdgeInsets.only(top: 5),
//                                    child: Text("Air-Conditioning"))
//                              ],
//                            )))),
//                Card(
//                    child: Container(
//                        child: InkWell(
//                            onTap: () {
//                              Navigator.push(
//                                context,
//                                MaterialPageRoute(
//                                    builder: (context) =>
//                                        ServiceDetailActivity("Brakes")),
//                              );
//                            },
//                            child: Column(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              crossAxisAlignment:
//                              CrossAxisAlignment.center,
//                              children: <Widget>[
//                                Image.asset(
//                                  "images/brakes.png",
//                                  height: 70,
//                                  width: 50,
//                                ),
//                                Container(
//                                    padding: EdgeInsets.only(top: 5),
//                                    child: Text("Brakes"))
//                              ],
//                            )))),
//                Card(
//                    child: Container(
//                        child: InkWell(
//                            onTap: () {
//                              Navigator.push(
//                                context,
//                                MaterialPageRoute(
//                                    builder: (context) =>
//                                        ServiceDetailActivity("Electrics")),
//                              );
//                            },
//                            child: Column(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              crossAxisAlignment:
//                              CrossAxisAlignment.center,
//                              children: <Widget>[
//                                Image.asset(
//                                  "images/electrics.png",
//                                  height: 70,
//                                  width: 50,
//                                ),
//                                Container(
//                                    padding: EdgeInsets.only(top: 5),
//                                    child: Text("Electrics"))
//                              ],
//                            )))),
//                Card(
//                    child: Container(
//                        child: InkWell(
//                            onTap: () {
//                              Navigator.push(
//                                context,
//                                MaterialPageRoute(
//                                    builder: (context) => ServiceDetailActivity("Oil Filter")),
//                              );
//                            },
//                            child: Column(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              crossAxisAlignment:
//                              CrossAxisAlignment.center,
//                              children: <Widget>[
//                                Image.asset(
//                                  "images/oil-filter.png",
//                                  height: 70,
//                                  width: 50,
//                                ),
//                                Container(
//                                    padding: EdgeInsets.only(top: 5),
//                                    child: Text("Oil Filter"))
//                              ],
//                            )))),
//                Card(
//                    child: Container(
//                        child: InkWell(
//                            onTap: () {
//                              Navigator.push(
//                                  context,
//                                  MaterialPageRoute(
//                                  builder: (context) =>
//                                  ServiceDetailActivity("Servicing")));
//                            },
//                            child: Column(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              crossAxisAlignment:
//                              CrossAxisAlignment.center,
//                              children: <Widget>[
//                                Image.asset(
//                                  "images/servicing.png",
//                                  height: 70,
//                                  width: 50,
//                                ),
//                                Container(
//                                    padding: EdgeInsets.only(top: 5),
//                                    child: Text("Servicing"))
//                              ],
//                            )))),
//                Card(
//                    child: Container(
//                        child: InkWell(
//                            onTap: () {
//                              Navigator.push(
//                                context,
//                                MaterialPageRoute(
//                                    builder: (context) =>
//                                        ServiceDetailActivity("Steering")),
//                              );
//                            },
//                            child: Column(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              crossAxisAlignment:
//                              CrossAxisAlignment.center,
//                              children: <Widget>[
//                                Image.asset(
//                                  "images/steering.png",
//                                  height: 70,
//                                  width: 50,
//                                ),
//                                Container(
//                                    padding: EdgeInsets.only(top: 5),
//                                    child: Text("Steering"))
//                              ],
//                            )))),
//                Card(
//                    child: Container(
//                        child: InkWell(
//                            onTap: () {
//                              Navigator.push(
//                                context,
//                                MaterialPageRoute(
//                                    builder: (context) => ServiceDetailActivity("Suspension")),
//                              );
//                            },
//                            child: Column(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              crossAxisAlignment:
//                              CrossAxisAlignment.center,
//                              children: <Widget>[
//                                Image.asset(
//                                  "images/suspension.png",
//                                  height: 70,
//                                  width: 50,
//                                ),
//                                Container(
//                                    padding: EdgeInsets.only(top: 5),
//                                    child: Text("Suspension"))
//                              ],
//                            )))),
//                Card(
//                    child: Container(
//                        child: InkWell(
//                            onTap: () {
//                              Navigator.push(
//                                context,
//                                MaterialPageRoute(
//                                    builder: (context) =>
//                                        ServiceDetailActivity("Tone Up")),
//                              );
//                            },
//                            child: Column(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              crossAxisAlignment:
//                              CrossAxisAlignment.center,
//                              children: <Widget>[
//                                Image.asset(
//                                  "images/tone-up.png",
//                                  height: 70,
//                                  width: 50,
//                                ),
//                                Container(
//                                    padding: EdgeInsets.only(top: 5),
//                                    child: Text("Tone-up"))
//                              ],
//                            )))),
//                Card(
//                    child: Container(
//                        child: InkWell(
//                            onTap: () {
//                              Navigator.push(
//                                context,
//                                MaterialPageRoute(
//                                    builder: (context) =>
//                                        ServiceDetailActivity("Tyre-S")),
//                              );
//                            },
//                            child: Column(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              crossAxisAlignment:
//                              CrossAxisAlignment.center,
//                              children: <Widget>[
//                                Image.asset(
//                                  "images/tyre-s.png",
//                                  height: 70,
//                                  width: 50,
//                                ),
//                                Container(
//                                    padding: EdgeInsets.only(top: 5),
//                                    child: Text("Tyre-S"))
//                              ],
//                            )))),
//                Card(
//                    child: Container(
//                        child: InkWell(
//                            onTap: () {
//                              Navigator.push(
//                                context,
//                                MaterialPageRoute(
//                                    builder: (context) =>
//                                        ServiceDetailActivity("Other")),
//                              );
//                            },
//                            child: Column(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              crossAxisAlignment:
//                              CrossAxisAlignment.center,
//                              children: <Widget>[
//                                Image.asset(
//                                  "images/other.gif",
//                                  height: 70,
//                                  width: 50,
//                                ),
//                                Container(
//                                    padding: EdgeInsets.only(top: 5),
//                                    child: Text("Other"))
//                              ],
//                            )))),
//
//
//              ]),

              // For later dynamic list

              GridView.builder(
                  padding: const EdgeInsets.all(15.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 4.0,
                  ),
                  itemCount: staticServiceList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      shadowColor: Color(0xffd9d9d9),
                      elevation: 20,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Color(0xff05135b)),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Container(
                            child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ServiceDetailActivity(
                                                staticServiceList[index].title,
                                                staticServiceList[index].body,
                                                staticServiceList[index]
                                                    .image)),
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      staticServiceList[index].image,
                                      height: 120,
                                      width: 100,
                                    ),
                                    Container(
                                        // padding: EdgeInsets.only(top: 5),
                                        child: Text(
                                            staticServiceList[index].title))
                                  ],
                                ))));
                  }),
        ),
      ),
    );
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

  getServiceList() async {
    showProgressBar();
    Map<String, String> header = {
      "Content-Type": "application/json",
    };
    await http
        .get("http://www.fasttrackemarat.com/feed/updates.json",
            headers: header)
        .then((res) {
      int status = res.statusCode;
      if (status == Rcode.successCode) {
        var result = json.decode(res.body);
        var values = result["facilities"] as List;
        String services = values[0]["services"];
        hideProgressBar();

        setState(() {
          serviceList = services.split(",");
        });
      } else {
        displaySnackbar(context, "An error has occured");
      }
    });
  }

  displaySnackbar(BuildContext context, msg) {
    final snackBar = SnackBar(
      content: Text('$msg'),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  List<ServiceModel> staticServiceList = [
    ServiceModel(
        title: "Air Conditioning",
        image: "images/ac.png",
        body:
            "Your auto air conditioner has one job: to keep you comfortable in the heat. Your A/C compressor is also responsible for assisting with removing moisture from the cabin of your car to keep the windows clear when you turn on the “defrost” function? Whether you’re concerned about windshield visibility, keeping the environment safe, or just being comfortable in your car during the heat of summer, be sure to get all of your auto air conditioning components checked before something breaks. So, stop on by today and have our expertly trained and Certified mechanics at Fasttrack - Emarat service your car’s Air Conditioning."),
    ServiceModel(
        title: "Brakes",
        image: "images/brakes.png",
        body:
            " Fasttrack – Emarat offers brake pads that provide the best design for vehicle application with options available for medium duty, passenger cars, light trucks, SUVs, medium duty, fleet and specialty applications. With a strong commitment to research and development, every brake pad is extensively tested to ensure OE fit, form and function. Fasttrack – Emarat dominates the aftermarket with first-to-market part numbers and industry leading coverage for brake pads. Whether it’s for high end applications, everyday drivers or budget-conscious customers. Fasttrack – Emarat performs various intricate tests on the vehicle for guaranteed premium performance and maximized safety. Parts that are available are Brake Pads, Brake Shoe, Disks, Brake Fluid Check/ Replace. Master Cylinder, Brake Booster, Wheel Cylinder, Calipers, Parking Brakes Bleeding, Hydraulic Lines Check/ Replace. Skimming for all Disks and Drums"),
    ServiceModel(
        title: "Electrics",
        image: "images/electrics.png",
        body:
            "Electrical systems are more complicated than ever, but they’re more reliable too, and easier to diagnose and repair with the proper equipment. At Fasttrack - Emarat, we have a full line of manufacturer-certified diagnostic tools. The tools, scanners, and equipment are the same as those used in dealership service departments or better. Our certified technicians know your car’s electrical components and can diagnose problems quickly and effectively. At Fasttrack - Emarat, we take a serious, targeted approach to pinpoint the problem and minimize the cost of repairs. This means that time is not wasted on guesswork and your wait in our waiting area is as short as we can make it. Electrical Services we provide Battery, Coils, Fuse, Light Check/ Replace. Electrical Fan, Starter Motor, Alternator, Windscreen Motor Check/Replace/ Spark Plugs, Ignition Coil, High Tension Wires Check/ Replace. Electrical Accessories Check/Replace."),
    ServiceModel(
        title: "Oil & Filters",
        image: "images/oil-filter.png",
        body:
            "  The fluids and air flowing through your engine need to stay clean to avoid clogging the narrow passageways. To keep these elements clean, your engine utilizes several well-placed filters. The filters sit in strategic locations and act as the first line of defense against potentially damaging dirt particles. To help the filters do their job, you must have them replaced regularly by a skilled technician. A replacement schedule is determined by the way you drive, total mileage between services, and vehicle manufacturer specifications. Fasttrack - Emarat technicians first look at your vehicle's filter change intervals assigned by the manufacturer to determine if your filters are in need of replacement. The intervals list both a time and mileage rating to consider. Our Technicians will then use their expertise to determine if your vehicle could benefit from a filter change. A visual inspection also assists in determining the right time to perform the fuel, oil and air filter replacement service. Our Services Include Oil Lubes Oil Filter At Fluid & Filter Replacement Maula Transmission Oil Differential Oil"),
    ServiceModel(
        title: "Servicing",
        image: "images/servicing.png",
        body:
            "At Fasttrack – Emarat we provide services from experts. This is the right address for outstanding service quality for your car. Whether you are looking for advice, repair or service work. The experts from Fasttrack - Emarat are fully equipped to deal with the latest automotive technology in vehicles of all makes and keep them in perfect working order. And so your car is always in the best possible hands when you take it to Fasttrack - Emarat Our Car Services include 20 point vehicle inspection. Minor Service: Check and Replace Lubricants. Major Service: All above and check/ replace timing set, ignition coil, high tension wires, spark plugs, air filter, engine cooling system, engine & transmission mountings, belts hoses, exhaust, under chassis lubrication etc."),
    ServiceModel(
        title: "Steering",
        image: "images/steering.png",
        body:
            "Ever notice that when you turn your car off, your steering wheel is suddenly hard to move? That’s because the steering in most modern vehicles is assisted by a finely-calibrated pressure system that gives drivers more sensitive control. This is called power steering, and when it isn’t functioning properly, it can be very difficult to operate your car safely. At Fasttrack - Emarat, our certified power-steering technicians are ready to assess the condition of your power steering system and if necessary to perform a full power steering fluid flush to clean it out and restore it to functionality. We proudly use Emarat steering fluid and power steering system cleaners for these procedures, and we’re ready to provide your vehicle with new steering fluid that meets the manufacturer’s standards. If there is another, more serious problem with your power steering belt or pump, our professionals can provide you with repair options for that too. Our Steering Services Include Check/ Replace all power steering hoses & Belts. Leakage Check/ Replace Steering Fluid, Oil Seal. Check/ Replace Steering Rack & Pinion assembly, upper & lower arms, Stabilizer Link, Ball Joint, Tie Rod Ends, Axel Boots etc."),
    ServiceModel(
        title: "Suspension",
        image: "images/suspension.png",
        body:
            "You might have a problem with one of the parts that forms the suspension system if handling the car is harder and the roads feel bumpier than before. A car suspension system has many purposes. It keeps the tires in contact with the road allowing a smooth ride over rough road, It also absorbs shocks for a better driving experience and It also allows the car to turn corners while maintain balance. The vehicle suspension system requires careful attention and periodical inspection. We at Fasttrack - Emarat perform a detailed inspection of your car suspension and fix the small issues to prevent the big ones. Suspensions in good working order make your car safer by reducing the brake distance which in turn can save lives. That’s why properly maintaining your cars suspension is very important. Keep your vehicle safe by bringing your car in for a suspension inspection at Fasttrack – Emarat. Our Services include Check/Replace all types of Shock Absorbers Check/Replace Coil Springs Check/ Replace Shock Mountings."),
    ServiceModel(
        title: "Tune Up",
        image: "images/tone-up.png",
        body:
            "Regular engine tune-ups bring power and efficiency back to your car. At Fasttrack - Emarat, we visually inspect all of your engine components and install new parts as needed. After a Fasttrack - Emarat car tune-up, you'll discover your engine starts easier, runs smoother and is more efficient. When you get car tune-ups based on your vehicle manufacturer's recommendations, you're investing in the long-term health of your car, saving you time and money. We promise that the tune-up services we perform at all Fasttrack - Emarat locations will be done right, the first time. Tune Up Service Includes Check/ Replace air filter, Furl Filter & Ignition Coils, High Tension Wires, Cables, Spark Plugs. Ignition Timing, Fuel Injectors, Fuel Pump, PCV Valve and Sensors, Compression & Carbon dioxide Check/Adjust."),
    ServiceModel(
        title: "Tyres",
        image: "images/tyre-s.png",
        body:
            "Fasttrack - Emarat has built its extensive reputation on providing exceptional tyre sales and service. If you are looking for a custom wheel package, our professional, knowledgeable team will help you choose according to your needs and budget. We always strive to provide comprehensive service and ensure that we match your vehicle and driving needs with the right tyre. We stock and fit a huge range of tyres for cars, 4WD, light commercial and SUV’s at competitive prices. We believe in giving you the best advice and a range of options to suit your requirements and budget. Our Services Include Free Tyre Inspection Tyre Change Wheel Balancing Wheel Alignment Inflate Tyres with Nitrogen Gas Tyre Rotation"),
    ServiceModel(
        title: "Other",
        image: "images/other.gif",
        body:
            "Fasttrack – Emarat provides several other services which are vital for your vehicle maintenance. Our Car Services include \n Approved Speed Limiter Installation \n Auto Glass Replacement & Repair \n Service Contract \n Engine and Brake Flush \n Head Light Restoration \n High Quality Additives \n A wide range of car care products (Air Fresheners, Injector Cleaner, Engine Degreaser, Brake Cleaners, Windshield Cleaner, Wiper Blades, High Quality Booster Cable, Tow Rope, Jerry Cans, Range of Philip Head Light Bulbs Etc. \n Car Wash Only Available at Bawadi Mall, Al Ain*"),
  ];
}
