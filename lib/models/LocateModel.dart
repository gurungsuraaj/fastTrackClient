class LocateModel {
  String name;
  String address;
  String telephone;
  String openinghours;
  String latlng;
  String googlemap;

  LocateModel(
      {this.name,
      this.address,
      this.openinghours,
      this.telephone,
      this.latlng,
      this.googlemap});
  factory LocateModel.fromJson(Map<String, dynamic> json) {
    return LocateModel(
      name: json['name'],
      address: json['address'],
      telephone: json['telephone'],
      openinghours: json['openinghours'],
      latlng: json['latlng'],
      googlemap: json['googlemap'],
    );
  }
}
