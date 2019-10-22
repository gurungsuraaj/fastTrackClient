class ServiceHistoryItem{

  String Description;
  String No;
  String Unit_Price;

  ServiceHistoryItem({this.Description, this.No, this.Unit_Price});
  factory ServiceHistoryItem.fromJson(Map<String, dynamic> json) {
    return ServiceHistoryItem(
      Description: json['Description'],
      No: json['No'],
      Unit_Price: json['Unit_Price'],
    );
  }
}