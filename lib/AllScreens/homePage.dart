import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:todo_list/AllScreens/addTaskScreen.dart';
import 'package:todo_list/Helper/sqliteHelper.dart';
import 'package:todo_list/Models/taskModel.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color color = Color(0xFF6C63FF);
  final DateFormat _dateFormat = DateFormat('MMM, dd, yyyy');
  List<TaskModel> _taskList = [];
  final rightnow = DateTime.now();
  DateTime now = DateTime.now();
  int _completedItemCount = 0;
  int _total = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _updateTaskList();
    print('init state called with data $_total');
  }

  String _checkDate(DateTime date) {
    String result;
    final taskDate = DateTime(date.year, date.month, date.day);
    final today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final tomorrow = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
    if (taskDate == today) {
      result = "Today";
      return result;
    } else if (taskDate == tomorrow) {
      result = "Tomorrow";
      return result;
    } else {
      return _dateFormat.format(date);
    }
  }

  _updateTaskList() async {
    List<TaskModel> taskList = await SqliteHelper.instance.getTaskList();
    setState(() {
      _taskList = taskList;
    });
    if (_taskList != null) {
      _total = _taskList.length;
      _completedItemCount =
          _taskList.where((element) => element.iscomplete == 1).toList().length;
    }
    print('update list called with data $_total');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: color,
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddTask(updateTaskList: _updateTaskList)),
          );
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(60.0)),
                color: color,
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 50, left: 40, bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "MY Todo List",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                        color: Colors.white,
                        letterSpacing: 2.0,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      "$_completedItemCount of $_total tasks completed",
                      style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.normal,
                        color: Colors.white,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height -
                  (MediaQuery.of(context).size.height / 4),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: ListView.builder(
                itemCount: _taskList.length,
                itemBuilder: (context, index) {
                  print('$index');
                  print(
                      '${_taskList[index].iscomplete}, ${_taskList[index].task}, ${_taskList[index].category}, ${_taskList[index].date}');
                  TaskModel task = _taskList[index];
                  return listTileWidget(task);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listTileWidget(TaskModel task) {
    return ListTile(
      leading: Checkbox(
        onChanged: ((value) async {
          value ? task.iscomplete = 1 : task.iscomplete = 0;
          await SqliteHelper.instance.updateTask(task);
          _updateTaskList();
        }),
        value: task.iscomplete == 1 ? true : false,
        checkColor: Colors.white,
        activeColor: Theme.of(context).primaryColor,
      ),
      title: Text(
        "${task.task}",
        style: TextStyle(
            fontSize: 18.0,
            letterSpacing: 0.0,
            decoration: task.iscomplete == 1
                ? TextDecoration.lineThrough
                : TextDecoration.none),
      ),
      subtitle: Text(
        "${_checkDate(task.date)}",
        style: TextStyle(
            fontSize: 12.0,
            letterSpacing: 1.0,
            decoration: task.iscomplete == 1
                ? TextDecoration.lineThrough
                : TextDecoration.none),
      ),
      trailing: Text(
        "${task.category}",
        style: TextStyle(
            fontSize: 8.0,
            decoration: task.iscomplete == 1
                ? TextDecoration.lineThrough
                : TextDecoration.none),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    AddTask(updateTaskList: _updateTaskList, task: task)));
      },
    );
  }
}
