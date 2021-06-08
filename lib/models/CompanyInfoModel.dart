class CompanyInfoModel {
  int statusCode;
  String key;
  String name;
  String address;
  String address2;
  String city;
  String phone;
  String serviceDateComment;
  String androidVersion;
  String iOSversionNo;

  String appStoreUrl;
  String playStoreUrl;
  String lapseServiceMessage;

  CompanyInfoModel(
      {this.statusCode,
      this.key,
      this.name,
      this.address,
      this.address2,
      this.city,
      this.phone,
      this.serviceDateComment,
      this.androidVersion,
      this.iOSversionNo,
      this.appStoreUrl,
      this.playStoreUrl,
      this.lapseServiceMessage
      });
}
