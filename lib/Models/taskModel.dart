


import 'package:flutter/material.dart';

class TaskModel{
  int id;
  String task;
  DateTime date;
  String category;
  int iscomplete;
  DateTime reminder;

  TaskModel({this.task, this.date, this.category, this.iscomplete, this.reminder});
  TaskModel.withId({this.id, this.task, this.date, this.category, this.iscomplete, this.reminder});

  Map<String, dynamic> toMap(){
    final map = Map<String, dynamic>();
    map['id'] = id;
    map['task'] = task;
    map['date'] = date.toIso8601String();
    map['category'] = category;
    map['iscomplete'] = iscomplete;
    map['reminder'] = reminder.toIso8601String();
    return map;
  }

  factory TaskModel.fromMap(Map<String, dynamic> map){
    return TaskModel.withId(id: map['id'], task: map['task'], date: DateTime.parse(map['date']), category: map['category'],
        iscomplete: map['iscomplete'], reminder: DateTime.parse(map['reminder']));
  }


}