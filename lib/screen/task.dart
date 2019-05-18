import 'package:flutter/material.dart';
import 'package:flutter_assignment_02/models/guest.dart';

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new TodoListState();
  }
}

class TodoListState extends State {
  int _index = 0;

  List<Todo> _todoItems = List();
  List<Todo> _doneItems = List();

  TodoProvider _db;

  TodoListState() {
    _db = TodoProvider();
  }
// เปิดฐานข้อมูล
  @override
  void initState() {
    super.initState();
    _db.open().then((result) {
      // getTodos();
    });
  }


  // void getTodos() {
  //   _db.getTodos().then((r) {
  //     setState(() {
  //       _todoItems = r;
  //     });
  //   });
  // }

  // void getEnd() {
  //   _db.getEnds().then((r) {
  //     setState(() {
  //       _doneItems = r;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {

    final List<Widget> _children = [
      ListView(
        children: _todoItems.map((todo) {
          // getTodos();
          }).toList(),
          ),
    ];

    final List topBar = <Widget>[
      IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/gotonewsub');
        },
      ),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          _db.deleteEnd().then((_) {
            // getEnd();
          });
        },
      )
    ];

    return new Scaffold(
      appBar: AppBar(
        title: Text("Todo"),
        actions: <Widget>[topBar[_index]],
        automaticallyImplyLeading: false,
        ),

      body: Center(child: _children[_index]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), title: Text('Task')),
          BottomNavigationBarItem(
              icon: Icon(Icons.done_all), title: Text("Completed"))
        ],
        onTap: (int index) {
          setState(() {
            _index = index;
            // if (index == 0) { getTodos();} 
            // else {getEnd();}
            
          });
        },
      ),
    );
  }
}
