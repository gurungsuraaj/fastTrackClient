class CustomerModel {
  String name;
  String phoneNumber;
  String email;
  int status;

  CustomerModel({this.name, this.phoneNumber, this.email,this.status});
  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      name: json['Name'],
      phoneNumber: json['Phone_No'],
      email: json['E_Mail'],
    );
  }
}
