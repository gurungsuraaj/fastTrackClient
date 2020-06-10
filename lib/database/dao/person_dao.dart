import 'package:floor/floor.dart';
import '../../models/person.dart';
 @dao
 abstract class PersonDao {
   @Query('SELECT * FROM Suraj')
   Future<List<Suraj>> findAllPersons();

   @Query('SELECT * FROM Suraj WHERE id = :id')
   Future<Suraj> findPersonById(int id);

   @insert
   Future<void> insertPerson(Suraj person);
 }