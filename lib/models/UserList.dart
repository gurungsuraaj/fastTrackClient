class UserList {
  int statusCode;
  String userId;
  String token;
  String latitude;
  String longitude;
  double distanceInMeter = 0.00;

  UserList(
      {this.token,
      this.latitude,
      this.longitude,
      this.distanceInMeter,
      this.userId});
}
