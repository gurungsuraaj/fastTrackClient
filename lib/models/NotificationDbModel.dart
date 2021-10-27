 import 'package:floor/floor.dart';

 @entity
 class NotificationDbModel{
   @primaryKey
    int id;
    String notificationTitle;
    String notificationBody;
    String dateTime;
   NotificationDbModel(this.id,this.notificationTitle,this.notificationBody,this.dateTime);
 }