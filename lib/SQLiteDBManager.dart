import 'package:sqflite/sqflite.dart';

class SqliteTableRecord {
  Map<String, dynamic> data;

  SqliteTableRecord(this.data);
}

class Note extends SqliteTableRecord {
  int get id => data['id'];

  String get front => data['front'];

  String get back => data['back'];

  int get failingTimes => data['failingTimes'];

  int get successfulTimes => data['successfulTimes'];

  DateTime get createdDate => DateTime.parse(data['createdDate']);

  // Constructors
  Note(Map<String, dynamic> data) : super(data);

  Note.frontBack(int id, String front, String back)
      : super({
          'id': id,
          'front': front,
          'back': back,
          'failingTimes': 0,
          'successfulTimes': 0,
          'createdDate': DateTime.now().toIso8601String(),
        });

  Note.frontBackCopyOthers(String front, String back, Note note)
      : super({
          'id': note.id,
          'front': front,
          'back': back,
          'failingTimes': note.failingTimes,
          'successfulTimes': note.successfulTimes,
          'createdDate': note.createdDate.toIso8601String(),
        });
}

mixin SqliteDbManager {
  Future<int> get newId async {
    final db = await database;
    List<Map<String, dynamic>> resultSet =
        await db.rawQuery("SELECT ROWID from $tableName");
    if (resultSet.isEmpty) {
      return 1;
    }
    return resultSet.last['rowid'] + 1;
  }

  Future<Database> get database;

  Future<List<SqliteTableRecord>> get tables async {
    final db = await database;
    List<Map<String, dynamic>> resultSet = await db.rawQuery(
        "SELECT name from sqlite_master where type='table' and name not like 'android%'");
    return List.generate(
        resultSet.length, (index) => SqliteTableRecord(resultSet[index]));
  }

  String get tableName {
    throw UnimplementedError(
        'Trying to access tableName, which is unimplemented.');
  }

  Future<void> insert(SqliteTableRecord record,
      {ConflictAlgorithm conflictAlgorithm}) async {
    final db = await database;
    db.insert(
      tableName,
      record.data,
      conflictAlgorithm: conflictAlgorithm,
    );
  }

  Future<void> update(Note record) async {
    final db = await database;
    db.update(tableName, record.data, where: "id = ?", whereArgs: [record.id]);
  }

  Future<void> delete(Note record) async {
    final db = await database;
    db.delete(tableName, where: "id=?", whereArgs: [record.id]);
  }

  Future<List<Map<String, dynamic>>> whereQuery(String where,
      {bool emptyCheck = false, String exception}) async {
    final db = await database;
    List<Map<String, dynamic>> resultSet =
        await db.query(tableName, where: where);
    if (emptyCheck && resultSet.isEmpty) throw exception;
    return resultSet;
  }

  Future<SqliteTableRecord> getById(String id) async {
    return SqliteTableRecord((await whereQuery("id=$id",
        emptyCheck: true,
        exception: 'No record with id: $id in $tableName'))[0]);
  }

  // Note: ROWID starts from 1
  Future<SqliteTableRecord> getByRowid(int rowId) async {
    return SqliteTableRecord((await whereQuery("ROWID=$rowId",
        emptyCheck: true, exception: 'No $rowId rows in $tableName'))[0]);
  }

  Future<List<Note>> getAllRecords() async {
    final db = await database;
    final resultSet = await db.query(tableName);
    return List.generate(
        resultSet.length, (index) => Note(resultSet[index]));
  }

  Future<void> createTable(String tableName) async {
    final db = await database;
    await db.execute(
        "create table $tableName (id int primary key unique, front text, back text, failingTimes integer, successfulTimes integer, createdDate date)");
  }

  Future<void> dropTable(String tableName) async {
    final db = await database;
    await db.execute("drop table $tableName");
  }
  
  Future<void> renameTableTo(String tableName, String newTableName) async {
    final db = await database;
    await db.execute("alter table $tableName rename to $newTableName");
  }
}
