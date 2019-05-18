import 'dart:async';
import 'package:sqflite/sqflite.dart';

final String tableToDo = 'todo';
final String columnId = '_id';
final String columnTitle = 'title';
final String columnDone = 'done';
final String columnstep = 'step';
final String columntree = 'tree';


class Todo {
  int _id;
  String _title;
  bool _done;
  int _tree;
  int _step;

  String get title => this._title;
  set title(String title) => this._title = title;
  bool get done => this._done;
  set done(bool done) => this._done = done;
  int get tree => this._tree;
  int get step => this._step;
  set step(int step) => this._step = step;
  set tree(int tree) => this._tree = tree;


  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTitle: _title,
      columnDone: done == true ? 1 : 0,
      columnstep: _step,
      columntree: _tree

    };
    if (_id != null) {
      map[columnId] = _id;
    }

    return map;
  }

// setค่าขอ้มูลลง ใน ตัวเเปร
  Todo({String subject, int tree, int step}) {
    this._title = subject;
    this._tree = tree;
    this._step = step;
  }
  // TodoTree({int tree}) {
  //   this._tree = tree;
  // }
  // TodoStep({int step}) {
  //   this._step = step;
  // }


// เข้าข้อมูลของ done 1 เท่านั้น
  Todo.fromMap(Map<String, dynamic> map) {
    _id = map[columnId];
    _title = map[columnTitle];
    done = map[columnDone] == 1;
    _step = map[columnstep];
    _tree = map[columntree];
  }
}


class TodoProvider {
  Database db;
  // เป็นการสร้างฐานข้อมูล
  Future open() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + "\todo.db";
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $tableToDo (
            $columnId integer primary key autoincrement,
            $columnTitle text not null,
            $columnDone integer not null,
            $columnstep integer not null,
            $columntree integer not null
          )
        ''');
      },
    );
  }

//ใส่ข้อมูลลง Database 
  Future<Todo> insert(Todo todo) async {
    db.insert(tableToDo, todo.toMap());
    return todo;
  }

// เอา todo ที่ done = 0 มา
  Future<List<Todo>> getTodos() async {
    var data = await db.query(tableToDo, where: '$columnDone = 0');
    return data.map((d) => Todo.fromMap(d)).toList();
  }

// เอา todo ที่ done = 1 มา
  Future<List<Todo>> getEnds() async {
    var data = await db.query(tableToDo, where: '$columnDone = 1');
    return data.map((d) => Todo.fromMap(d)).toList();
  }

// เอา ค่า todo ที่ต้องใส่ id มา
  Future<Todo> getTodo(int id) async {
    List<Map> maps = await db.query(
      tableToDo,
      columns: [columnId, columnTitle, columnDone, columnstep, columntree],
      where: '$columnId = ?',
      whereArgs: [id],);
    if (maps.length > 0) {
      return new Todo.fromMap(maps.first);
    }
    return null;
  }

// เปลี่ยนค่า todo 
  Future setUpdate(Todo todo) async {
    await db.update(
      tableToDo,
      todo.toMap(),
      where: '$columnId = ?',
      whereArgs: [todo._id],);
  }



// ลบ todo ที่ ต้องใส่ id
  Future delete(int id) async {
    return await db.delete(tableToDo, where: "$columnId = ?", whereArgs: [id]);
  }
//  ลบ todo ทุกอันที่ done ช 1
  Future deleteEnd() async {
    await db.delete(
      tableToDo,
      where: '$columnDone = 1',);
  }

// ปิด database 
  Future close() async => db.close();
}
