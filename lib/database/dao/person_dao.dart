import 'package:floor/floor.dart';
import '../../models/person.dart';
 @dao
 abstract class PersonDao {
   @Query('SELECT * FROM Person')
   Future<List<Person>> findAllPersons();

   @Query('SELECT * FROM Person WHERE id = :id')
   Future<Person> findPersonById(int id);

   @insert
   Future<void> insertPerson(Person person);
 }