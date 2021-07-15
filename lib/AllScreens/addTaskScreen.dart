import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/Helper/sqliteHelper.dart';
import 'package:todo_list/Models/taskModel.dart';

class AddTask extends StatefulWidget {
  final TaskModel task;
  final Function updateTaskList;

  AddTask({this.updateTaskList, this.task});

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  String _task = "";
  String _category;
  DateTime _reminder;
  bool _reminderStatus = false;
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  String _timeHolder;
  Color color = Color(0xFF6C63FF);
  final _formKey = GlobalKey<FormState>();
  final DateFormat _dateFormat = DateFormat('MMM, dd, yyyy');
  final List<String> _categories = ["Personal", "Work", "Business"];
  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.task != null) {
      _task = widget.task.task;
      _dateController.text = _dateFormat.format(widget.task.date);
      _date = widget.task.date;
      _category = widget.task.category;
    } else {
      _dateController.text = _dateFormat.format(_date);
    }
    _timeHolder = "${_time.hour.toString()}:${_time.minute.toString()}";
    //_updateTaskList();
  }

  _setReminder(){

  }

  _handleDatePicker() async {
    final DateTime date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));

    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      _dateController.text = _dateFormat.format(date);
    }
  }

  _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      TaskModel task = TaskModel(
          task: _task, category: _category, date: _date, reminder: _reminderStatus ? _reminder :  _date);
      if (widget.task == null) {
        task.iscomplete = 0;
        print('New task');
        await SqliteHelper.instance.insertTask(task);
      } else {
        task.id = widget.task.id;
        task.iscomplete = widget.task.iscomplete;
        print('Updating task');
        await SqliteHelper.instance.updateTask(task);
        print('Task updated');
      }
      print('$_task, $_date, $_category');
      widget.updateTaskList();
      Navigator.pop(context);
    }
  }

  Future<Null> _showTimePicker(BuildContext context) async{

    final timePicked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if(timePicked != null && timePicked != _time)
    {
      setState(() {
        _time = timePicked;
        _timeHolder = "${_time.toString().substring(10, 15)}";
        print("${_time.toString()}");
      });
    }
  }

  _delete() {
    SqliteHelper.instance.deleteTask(widget.task.id);
    widget.updateTaskList();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.check,
        ),
        onPressed: () {
          print("save button clicked");
          _submit();
        },
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 45.0, left: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 30.0,
                          color: color,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        widget.task == null ? "New Task" : "Update Task",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Form(
                key: _formKey,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter task';
                          }
                          return null;
                        },
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                          labelText: "Task",
                          labelStyle: TextStyle(fontSize: 18.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                        ),
                        onSaved: (value) => _task = value,
                        initialValue: _task,
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        controller: _dateController,
                        onTap: () => _handleDatePicker(),
                        style: TextStyle(fontSize: 18.0),
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "Date",
                          labelStyle: TextStyle(fontSize: 18.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      DropdownButtonFormField(
                        icon: Icon(Icons.arrow_drop_down_circle),
                        iconSize: 25.0,
                        iconEnabledColor: Theme.of(context).primaryColor,
                        items: _categories.map((String category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(
                              category,
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.black),
                            ),
                          );
                        }).toList(),
                        validator: (value) {
                          if (_category == null) {
                            return 'Please select a category';
                          }
                          return null;
                        },
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                          labelText: "Category",
                          labelStyle: TextStyle(fontSize: 18.0),
                        ),
                        onSaved: (value) => _category = value,
                        onChanged: (value) {
                          setState(() {
                            _category = value;
                          });
                        },
                        value: _category,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 5.0),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.white,
                  elevation: 4.5,
                  child: ExpansionTile(
                    title: Text(
                      "Reminder(optional)",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(width: 12.0),
                          GestureDetector(
                            onTap: (){
                              _showTimePicker(context);
                            },
                            child: Text(
                              "$_timeHolder",
                              style: TextStyle(
                                fontSize: 60.0,
                              ),
                            ),
                          ),
                          SizedBox(width: 35.0),
                          Switch(
                            value: _reminderStatus,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (value) {
                              setState(() {
                                _reminderStatus = !_reminderStatus;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              widget.task != null
                  ? Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                      height: 48.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: TextButton(
                        child: Text(
                          "Delete",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        onPressed: _delete,
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
