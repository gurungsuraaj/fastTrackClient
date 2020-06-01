class Promo {
  String name;
  String banner;
  String details;
  String image;

  Promo({this.name, this.banner, this.details,this.image});
  factory Promo.fromJson(Map<String, dynamic> json) {
    return Promo(
      name: json['name'],
      banner: json['banner'],
      details: json['details'],
      image: json['image']
    );
  }
}
