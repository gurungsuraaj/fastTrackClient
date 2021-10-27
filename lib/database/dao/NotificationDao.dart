import 'package:fasttrackgarage_app/models/NotificationDbModel.dart';
import 'package:floor/floor.dart';

@dao
abstract class NotificationDao{
  @Query('SELECT * FROM NotificationDbModel')
  Future<List<NotificationDbModel>> findAllNotification();

  @Query('SELECT * FROM NotificationDbModel WHERE id = :id')
  Future<NotificationDbModel> findNotificationById(int id);

  @insert
  Future<void> insertNotification(NotificationDbModel notification);

  @Query("DELETE FROM NotificationDbModel WHERE id = :id")
  Future<void> deleteNotification(int id);



}