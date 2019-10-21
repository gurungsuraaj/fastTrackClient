import 'dart:async';
import 'package:floor/floor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;   
import "../models/person.dart";

 import 'dao/person_dao.dart';
 

part 'AppDatabase.g.dart'; // the generated code will be there

 @Database(version: 1, entities: [Person])
 abstract class AppDatabase extends FloorDatabase {
   PersonDao get personDao;
 }