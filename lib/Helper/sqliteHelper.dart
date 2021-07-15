import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_list/Models/taskModel.dart';

class SqliteHelper{
  static final SqliteHelper instance = SqliteHelper._instance();
  SqliteHelper._instance();

  final String colId = 'id';
  final String colTask = 'task';
  final String colDate = 'date';
  final String colCategory = 'category';
  final String colIscomplete = 'iscomplete';
  final String colReminder = 'reminder';
  final String tableTask = 'tasks_table';

  static Database _db;
  final int version = 1;

  Future<Database> get db async{
    if(_db == null){
      _db = await init();
    }
    return _db;
  }

  Future<Database> init() async{
    Directory dir = await getApplicationDocumentsDirectory();
    String dbPath = join(dir.path, 'tasks.db');
    Database dbTasks = await openDatabase(dbPath, version: version, onCreate: _createDb);
    return dbTasks;
  }

  Future _createDb(Database db, int version) async{
    String query = 'CREATE TABLE $tableTask ($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTask TEXT, $colDate TEXT, $colCategory TEXT, $colIscomplete INTEGER, $colReminder TEXT)';
    await db.execute(query);
  }

  Future <List<TaskModel>> getTaskList() async{
    Database db = await this.db;
    List<TaskModel> taskList = [];
    List<Map<String, dynamic>> taskmaplist = await db.query(tableTask);
    taskmaplist.forEach((element) {
      taskList.add(TaskModel.fromMap(element));
    });
    taskList.sort((taskA, taskB) => taskA.date.compareTo(taskB.date));
    return taskList;
  }

  Future <int> insertTask(TaskModel task) async{
    Database db = await this.db;
    int result = await db.insert(tableTask, task.toMap());
    return result;
  }

  Future <int> updateTask(TaskModel task) async{
    Database db = await this.db;
    int result = await db.update(tableTask, task.toMap(), where: '$colId = ?', whereArgs: [task.id]);
    return result;
  }

  Future <int> deleteTask(int id) async{
    Database db = await this.db;
    int result = await db.delete(tableTask, where: '$colId = ?', whereArgs: [id]);
    return result;
    
  }

}