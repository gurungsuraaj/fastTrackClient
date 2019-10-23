class InventoryCheckItem{

  String Description;

  InventoryCheckItem({this.Description});
  factory InventoryCheckItem.fromJson(Map<String, dynamic> json) {
    return InventoryCheckItem(
      Description: json['Description'],
    );
  }
}