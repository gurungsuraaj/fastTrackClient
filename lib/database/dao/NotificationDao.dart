import 'package:fasttrackgarage_app/models/NotificationDbModel.dart';
import 'package:floor/floor.dart';

@dao
abstract class NotificationDao{
  @Query('SELECT * FROM NotificationDbModel')
  Future<List<NotificationDbModel>> findAllNotification();

  @Query('SELECT * FROM Suraj WHERE id = :id')
  Future<NotificationDbModel> findPersonById(int id);

  @insert
  Future<void> insertPerson(NotificationDbModel person);

}