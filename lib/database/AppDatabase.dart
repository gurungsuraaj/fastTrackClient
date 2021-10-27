import 'dart:async';
import 'package:fasttrackgarage_app/database/dao/NotificationDao.dart';
import 'package:fasttrackgarage_app/models/NotificationDbModel.dart';
import 'package:floor/floor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;   
import "../models/person.dart";

 import 'dao/person_dao.dart';
 

part 'AppDatabase.g.dart'; // the generated code will be there

 @Database(version: 1, entities: [Suraj,NotificationDbModel])
 abstract class AppDatabase extends FloorDatabase {
   PersonDao get personDao;
   NotificationDao get notificationDao;
 }