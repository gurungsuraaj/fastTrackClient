import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class LocateModel {
  String name;
  String address;
  String telephone;
  String openinghours;
  String latlng;
  String googlemap;
  String whatsAppNum;
  bool openingStatus;
  double distance;
  LocateModel(
      {this.name,
      this.address,
      this.openinghours,
      this.telephone,
      this.latlng,
      this.googlemap,
      this.whatsAppNum,
      this.openingStatus,
      this.distance});
  factory LocateModel.fromJson(Map<String, dynamic> json,
      {double longitude, double latitude}) {
    // Calculation of branch location open and close time for the UI.
    DateFormat dateFormat = DateFormat("HH:mm");
    DateTime now = DateTime.now().toLocal();
    String dateFromAPI = json['openinghours'];
    bool status;
    if (dateFromAPI == "24hours") {
      status = true;
    } else {
      final time = dateFormat.parse(DateFormat.Hm().format(now));
      String openingTime = dateFromAPI.substring(0, 6);
      String closingTime = dateFromAPI.substring(11, 16);
      String updatedClosingTime;

      String extractPM =
          dateFromAPI.substring((dateFromAPI.length - 2), dateFromAPI.length);
      if (extractPM == "pm") {
        String finalTime =
            ((int.parse(closingTime.substring(0, 2)) + 12)).toString();
        updatedClosingTime = "$finalTime:${closingTime.substring(3, 5)}";
      } else {}

      final prevDate = dateFormat.parse(openingTime);
      final afterDate = dateFormat.parse(updatedClosingTime);

      if (time.isAfter(prevDate) && time.isBefore(afterDate)) {
        status = true;
      } else {
        status = false;
      }
    }

    /* Calculation of distance between the user and store and 
          sort based on the nearest location. */

    var latLng = json["latlng"].split(',');

    /* Disance between the current user and store */
    double calculatedDistance;
    if (latitude != null && longitude != null) {
      calculatedDistance = Geolocator.distanceBetween(double.parse(latLng[0]),
          double.parse(latLng[1]), latitude, longitude);
    }
    print(
        "location ${latLng[0]} , ${latLng[0]} , distance $calculatedDistance");
    return LocateModel(
      name: json['name'],
      address: json['address'],
      telephone: json['telephone'],
      openinghours: json['openinghours'],
      latlng: json['latlng'],
      googlemap: json['googlemap'],
      whatsAppNum: json['whatsapp'],
      openingStatus: status,
      distance: calculatedDistance,
    );
  }
}
