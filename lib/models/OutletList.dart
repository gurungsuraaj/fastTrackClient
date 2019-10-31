class OutletList {
  String Name;
  String City;
  String Address;

  OutletList({this.Name, this.City, this.Address});
  factory OutletList.fromJson(Map<String, dynamic> json) {
    return OutletList(
      Name: json['Name'],
      City: json['City'],
      Address: json['Address'],
    );
  }
}
