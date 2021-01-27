class CustomerModel {
  String name;
  String phoneNumber;
  String email;
  int status;
  String customerNo;
  String password;

  CustomerModel({this.name, this.phoneNumber, this.email,this.status,this.customerNo,this.password});
  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      name: json['Name'],
      phoneNumber: json['Phone_No'],
      email: json['E_Mail'],
      customerNo: json['No'],
      password: json['Password']
    );
  }
}
