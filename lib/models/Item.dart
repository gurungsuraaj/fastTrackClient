class Item {
  String Description;
  String No;
  String Unit_Price;

  Item({this.Description, this.No, this.Unit_Price});
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      Description: json['Description'],
      No: json['No'],
      Unit_Price: json['Unit_Price'],
    );
  }
}
