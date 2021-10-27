

class MakeModel {
  String name;
  List<String> model;

  MakeModel({this.name, this.model});

  MakeModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    model = json['model'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['model'] = this.model;
    return data;
  }
}
