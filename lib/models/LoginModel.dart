class LoginModel {
  int status;
  String customerNo;
  String customerName;
  String customerEmail;
  String errResponse;
  LoginModel(
      {this.status,
      this.customerNo,
      this.customerName,
      this.customerEmail,
      this.errResponse});
}
