class CompanyInfoModel {
  int statusCode;
  String key;
  String name;
  String address;
  String address2;
  String city;
  String phone;
  String serviceDateComment;
  String versionNo;
  String appStoreUrl;
  String playStoreUrl;

  CompanyInfoModel(
      {this.statusCode,
      this.key,
      this.name,
      this.address,
      this.address2,
      this.city,
      this.phone,
      this.serviceDateComment,
      this.versionNo,
      this.appStoreUrl,
      this.playStoreUrl
      });
}
