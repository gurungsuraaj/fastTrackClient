class Promo {
  String name;
  String banner;
  String details;

  Promo({this.name, this.banner, this.details});
  factory Promo.fromJson(Map<String, dynamic> json) {
    return Promo(
      name: json['name'],
      banner: json['banner'],
      details: json['details'],
    );
  }
}
