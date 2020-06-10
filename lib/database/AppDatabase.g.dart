// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppDatabase.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final database = _$AppDatabase();
    database.database = await database.open(
      name ?? ':memory:',
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  PersonDao _personDaoInstance;

  NotificationDao _notificationDaoInstance;

  Future<sqflite.Database> open(String name, List<Migration> migrations,
      [Callback callback]) async {
    final path = join(await sqflite.getDatabasesPath(), name);

    return sqflite.openDatabase(
      path,
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Suraj` (`id` INTEGER, `name` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `NotificationDbModel` (`id` INTEGER, `notificationTitle` TEXT, `notificationBody` TEXT, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
  }

  @override
  PersonDao get personDao {
    return _personDaoInstance ??= _$PersonDao(database, changeListener);
  }

  @override
  NotificationDao get notificationDao {
    return _notificationDaoInstance ??=
        _$NotificationDao(database, changeListener);
  }
}

class _$PersonDao extends PersonDao {
  _$PersonDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _surajInsertionAdapter = InsertionAdapter(
            database,
            'Suraj',
            (Suraj item) =>
                <String, dynamic>{'id': item.id, 'name': item.name});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _surajMapper = (Map<String, dynamic> row) =>
      Suraj(row['id'] as int, row['name'] as String);

  final InsertionAdapter<Suraj> _surajInsertionAdapter;

  @override
  Future<List<Suraj>> findAllPersons() async {
    return _queryAdapter.queryList('SELECT * FROM Suraj', mapper: _surajMapper);
  }

  @override
  Future<Suraj> findPersonById(int id) async {
    return _queryAdapter.query('SELECT * FROM Suraj WHERE id = ?',
        arguments: <dynamic>[id], mapper: _surajMapper);
  }

  @override
  Future<void> insertPerson(Suraj person) async {
    await _surajInsertionAdapter.insert(
        person, sqflite.ConflictAlgorithm.abort);
  }
}

class _$NotificationDao extends NotificationDao {
  _$NotificationDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _notificationDbModelInsertionAdapter = InsertionAdapter(
            database,
            'NotificationDbModel',
            (NotificationDbModel item) => <String, dynamic>{
                  'id': item.id,
                  'notificationTitle': item.notificationTitle,
                  'notificationBody': item.notificationBody
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _notificationDbModelMapper = (Map<String, dynamic> row) =>
      NotificationDbModel(row['id'] as int, row['notificationTitle'] as String,
          row['notificationBody'] as String);

  final InsertionAdapter<NotificationDbModel>
      _notificationDbModelInsertionAdapter;

  @override
  Future<List<NotificationDbModel>> findAllNotification() async {
    return _queryAdapter.queryList('SELECT * FROM NotificationDbModel',
        mapper: _notificationDbModelMapper);
  }

  @override
  Future<NotificationDbModel> findPersonById(int id) async {
    return _queryAdapter.query('SELECT * FROM Suraj WHERE id = ?',
        arguments: <dynamic>[id], mapper: _notificationDbModelMapper);
  }

  @override
  Future<void> insertPerson(NotificationDbModel person) async {
    await _notificationDbModelInsertionAdapter.insert(
        person, sqflite.ConflictAlgorithm.abort);
  }
}
