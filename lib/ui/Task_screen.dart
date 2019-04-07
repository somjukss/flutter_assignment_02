import 'package:flutter/material.dart';
import './NewSubject_screen.dart';
import 'package:flutter_assignment_02/model/todo.dart';

class TaskScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TaskScreenState();
  }
}

class TaskScreenState extends State {
  int current_state = 0;
  int counttask = 0;
  int countcomplete = 0;
  List<Todo> taskList;
  List<Todo> completeList;

  TodoProvider tdProv = TodoProvider();
  @override
  void getTodoList() async {
    await tdProv.open("todo.db");
    tdProv.getAllTodos().then((task) {
      setState(() {
        this.taskList = task;
        this.counttask = task.length;
      });
    });
    tdProv.getAllDoneTodos().then((complete) {
      setState(() {
        this.completeList = complete;
        this.countcomplete = complete.length;
      });
    });
  }

  Widget build(BuildContext context) {
    getTodoList();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Todo"),
          actions: <Widget>[
            current_state == 0
                ? IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewSubject()));
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      tdProv.deleteAllDoneTodo();
                    },
                  )
          ],
          backgroundColor: Colors.pink,
        ),
        body: Center(
            child: current_state == 0
                // taskscreen
                ? counttask == 0
                    ? Text("No data found..")
                    : ListView.builder(
                        itemCount: counttask,
                        itemBuilder: (context, int position) {
                          return Column(
                            children: <Widget>[
                              Divider(
                                height: 1.0,
                                color: Colors.black,
                              ),
                              CheckboxListTile(
                                  title: Text(
                                    this.taskList[position].title,
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.redAccent),
                                  ),
                                  onChanged: (bool value) {
                                    setState(() {
                                      taskList[position].done = value;
                                    });
                                    tdProv.update(taskList[position]);
                                  },
                                  value: taskList[position].done),
                            ],
                          );
                        },
                      )
                // completeScreen
                : countcomplete == 0
                    ? Text("No data found..")
                    : ListView.builder(
                        itemCount: countcomplete,
                        itemBuilder: (context, int position) {
                          return Column(
                            children: <Widget>[
                              Divider(
                                height: 1.0,
                                color: Colors.black,
                              ),
                              CheckboxListTile(
                                  title: Text(
                                    this.completeList[position].title,
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.green),
                                  ),
                                  onChanged: (bool value) {
                                    setState(() {
                                      completeList[position].done = value;
                                    });
                                    tdProv.update(completeList[position]);
                                  },
                                  value: completeList[position].done),
                            ],
                          );
                        },
                      )),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: current_state,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.list), title: Text('Task')),
            BottomNavigationBarItem(
                icon: Icon(Icons.done_all), title: Text('Complete'))
          ],
          onTap: (int index) {
            setState(() {
              current_state = index;
            });
          },
        ),
      ),
    );
  }
}
