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
  LocateModel(
      {this.name,
      this.address,
      this.openinghours,
      this.telephone,
      this.latlng,
      this.googlemap,
      this.whatsAppNum,
      this.openingStatus});
  factory LocateModel.fromJson(Map<String, dynamic> json) {
    DateFormat dateFormat = DateFormat("HH:mm");
    DateTime now = DateTime.now().toLocal();
    String dateFromAPI = json['openinghours'];
    bool status;
    if (dateFromAPI == "24hours") {
      print("24 hour");
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
        print("Time $updatedClosingTime");
      } else {}

      final prevDate = dateFormat.parse(openingTime);
      final afterDate = dateFormat.parse(updatedClosingTime);

      if (time.isAfter(prevDate) && time.isBefore(afterDate)) {
        print("Inside");
        status = true;
      } else {
        status = false;
      }
    }

    return LocateModel(
        name: json['name'],
        address: json['address'],
        telephone: json['telephone'],
        openinghours: json['openinghours'],
        latlng: json['latlng'],
        googlemap: json['googlemap'],
        whatsAppNum: json['whatsapp'],
        openingStatus: status);
  }
}
