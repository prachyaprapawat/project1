import 'package:sqflite/sqflite.dart';

final String tableGuest = 'guest';
final String columnid = 'id';
final String columnname = 'name';
final String columnkm = 'km';
final String columntotal = 'total';
final String columnstep = 'step';
final String columnlvl = 'lvl';
final String columnremain = 'remainstep';
final String columntree = 'tree';

class guest {


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


  guest.fromMap(Map<String, dynamic> map) {
    _tree = map[columntree];
    _step = map[columnstep];
    _name = map[columnname];
    _remain = map[columnremain];
    _km = map[columnkm];
    _id = map[columnid];
    _total = map[columntotal];
    _lvl = map[columnlvl];
  }
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
   

    return map;
  }
  guest() {
    this._tree =0;
    this._step=0;
    this._name='Guest';
    this._remain=0;
    this._km=0;
    this._id=0;
    this._total=0;
    this._lvl=0;
  }
}

class guestProvider {
  Database db;
  
  Future open(String path) async {
    print("on open function");
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $tableGuest (
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
    });
  }

  // Future<guest> insert(guest guest) async{
  //   guest.id = await db.insert(
  //     tableguest,
  //     guest.toMap()
  //     );
  //   return guest;
  // }

  // Future<guest> getguest(int id) async{
  //   List<Map> maps = await db.query(tableguest,
  //       columns: [columnId, columnDone, columnTitle],
  //       where: "$columnId = ?",
  //       whereArgs: [id]);
  //       if (maps.length > 0) {
  //         return new guest.fromMap(maps.first);
  //       }
  //       return null;
  // }

//   Future<int> delete(int id) async{
//     return await db.delete(tableguest, where: "$columnid = ?", whereArgs: [id]);
//   }

//   Future<int> update(guest guest) async{
//     return await db.update(tableguest guest.toMap(),
//         where: "$columnid = ?", whereArgs: [guest.id]);
//   }
//   //test
//   Future<List<guest>> getto() async{
//     var guest =await db.query(tableguest, where: "$columnid = 0");
//     return guest.map((string) => guest.fromMap(string)).toList();
//   }
//   //test
//   Future deleteAllCompguest() async{
//     await db.delete(tableguest, where: "$columnid = 1");
//   }
//   //test
//   Future<List<guest>> getall() async{
//     await this.open("guest.db");
//     List<Map<String, dynamic>> guest = await db.query(tableguest,where: "$columnid = 0");
//     if(db != null){
//       print('data is null -------------------'+db.rawQuery('SELECT * FROM guest').toString());
//     }
//     // print("pang: =>>"+guest.map((string) =>guest.fromMap(string)).toList().toString());
//     return guest.map((string) =>guest.fromMap(string)).toList();
//   }

  
//   Future close() => db.close();
// }