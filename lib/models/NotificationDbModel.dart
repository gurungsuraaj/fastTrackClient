 import 'package:floor/floor.dart';

 @entity
 class NotificationDbModel{
   @primaryKey
   final int id;
   final String notificationTitle;
   final String notificationBody;
   NotificationDbModel({this.id,this.notificationTitle,this.notificationBody});
 }