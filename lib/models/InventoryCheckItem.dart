class InventoryCheckItem{

  String description;

  InventoryCheckItem({this.description});
  factory InventoryCheckItem.fromJson(Map<String, dynamic> json) {
    return InventoryCheckItem(
      description: json['Description'],
    );
  }
}