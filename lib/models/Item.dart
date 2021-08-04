class Item {
  String description;
  String no;
  String unitPrice;

  Item({this.description, this.no, this.unitPrice});
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      description: json['Description'],
      no: json['No'],
      unitPrice: json['Unit_Price'],
    );
  }
}
