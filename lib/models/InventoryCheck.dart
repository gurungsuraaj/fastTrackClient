class InventoryItem {
  String firstName;
  String lastName;
 
  InventoryItem({this.firstName, this.lastName});
 
  static List<InventoryItem> getItems() {
    return <InventoryItem>[
      InventoryItem(firstName: "Aaryan", lastName: "Shah"),
      InventoryItem(firstName: "Ben", lastName: "John"),
      InventoryItem(firstName: "Carrie", lastName: "Brown"),
      InventoryItem(firstName: "Deep", lastName: "Sen"),
      InventoryItem(firstName: "Emily", lastName: "Jane"),
    ];
  }
}