class OutletList {
  String name;
  String city;
  String address;

  OutletList({this.name, this.city, this.address});
  factory OutletList.fromJson(Map<String, dynamic> json) {
    return OutletList(
      name: json['Name'],
      city: json['City'],
      address: json['Address'],
    );
  }
}
