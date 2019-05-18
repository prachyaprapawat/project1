import 'dart:async';
import 'package:sqflite/sqflite.dart';


final String tableToDo = 'todo';
final String columnid = 'id';
final String columnname = 'name';
final String columnkm = 'km';
final String columntotal = 'total';
final String columnstep = 'step';
final String columnlvl = 'lvl';
final String columnremain = 'remainstep';
final String columntree = 'tree';


class Todo {

  int _tree;
  int _step;
  String _name;
  int _remain;
  int _km;
  int _id;
  int _total;
  int _lvl;
  

  String get name => this._name;
  int get tree => this._tree;
  int get step => this._step;
  int get remain => this._remain;
  int get km => this._km;
  int get id => this._id;
  int get total => this._total;
  int get lvl => this._lvl;
  set remain(int remain) => this._remain = remain;
  set km(int km) => this._km = km;
  set id(int id) => this._id = id;
  set total(int total) => this._total = total;
  set lvl(int lvl) => this._lvl = lvl;
  set name(String name) => this._name = name;
  set step(int step) => this._step = step;
  set tree(int tree) => this._tree = tree;


  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnstep: _step,
      columntree: _tree,
      columnid : _id,
      columnname : _name,
      columnkm : _km,
      columntotal : _total,
      columnlvl : _lvl,
      columnremain : _remain

    };
    if (_id != null) {
      map[columnid] = _id;
    }

    return map;
  }

// setค่าขอ้มูลลง ใน ตัวเเปร
  Todo() {
    this._tree =0;
    this._step=0;
    this._name='Guest';
    this._remain=0;
    this._km=0;
    this._id=0;
    this._total=0;
    this._lvl=0;
  }
  // TodoTree({int tree}) {
  //   this._tree = tree;
  // }
  // TodoStep({int step}) {
  //   this._step = step;
  // }


// เข้าข้อมูลของ done 1 เท่านั้น
  Todo.fromMap(Map<String, dynamic> map) {
    
    _tree = map[columntree];
    _step = map[columnstep];
    _name = map[columnname];
    _remain = map[columnremain];
    _km = map[columnkm];
    _id = map[columnid];
    _total = map[columntotal];
    _lvl = map[columnlvl];
 
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
            $columnid integer primary key autoincrement,
            $columntree integer,
            $columnstep integer not null,
            $columnname text not null,
            $columnremain integer not null,
            $columnkm integer not null,
            $columntotal integer not null,
            $columnlvl integer not null
          )
        ''');
      },
    );
  }

//ใส่ข้อมูลลง Database 
  Future<Todo> insert(Todo todo) async {
    // if(tableid.length == 0){
    //   asdsad
    // }
    db.insert(tableToDo , todo.toMap());
    return todo;
  }

// เอา todo ที่ done = 0 มา
  // Future<List<Todo>> getTodos() async {
  //   var data = await db.query('GUEST', where: '$columnDone = 0');
  //   return data.map((d) => Todo.fromMap(d)).toList();
  // }

// เอา todo ที่ done = 1 มา
  // Future<List<Todo>> getEnds() async {
  //   var data = await db.query('GUEST', where: '$columnDone = 1');
  //   return data.map((d) => Todo.fromMap(d)).toList();
  // }

// เอา ค่า todo ที่ต้องใส่ id มา
  Future<Todo> getTodo(int id) async {
    List<Map> maps = await db.query(
      tableToDo,
      
      columns: [columntree, columnstep, columnname, columnremain, columnkm,columnid,columntotal,columnlvl],
      where: '$columnid = ?',
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
      where: '$columnid = ?',
      whereArgs: [todo._id],);
  }



// ลบ todo ที่ ต้องใส่ id
  Future delete(int id) async {
    return await db.delete(tableToDo , where: "$columnid = ?", whereArgs: [id]);
  }
//  ลบ todo ทุกอันที่ done ช 1
  Future deleteEnd() async {
    await db.delete(
      tableToDo,
      where: '$columnid = 1',);
  }

// ปิด database 
  Future close() async => db.close();
}
