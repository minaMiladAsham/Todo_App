import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/archieved_task_screen/archieved_task_screen.dart';
import 'package:todo/modules/done_task_screen/done_task_screen.dart';
import 'package:todo/modules/new_task_screen/new_task_screen.dart';
import 'package:todo/shared/cubit/states.dart';

class TodoCubit extends Cubit<TodoStates>{
  TodoCubit() : super (TodoInitialState());
  static TodoCubit get(context) => BlocProvider.of(context);

 int bottomNavigationBarCurrentIndex = 0;
 IconData fabIconCubit = Icons.edit ;
 bool isBottomSheetOpen = false;
 List<Map> newTasks = [];
 List<Map> doneTasks = [];
 List<Map> archievedTasks = [];
 Database? database;


 List<Widget> screens =[
   NewTaskScreen(),
   DoneTaskScreen(),
   ArchievedTaskScreen(),
 ];

 void changeBottomNavigationBar(index){
   bottomNavigationBarCurrentIndex = index;
   emit(BottomNavigationBarState());
 }

 void changeBSheetAndFab (bool isOpen , IconData fabIcon){
   isBottomSheetOpen = isOpen;
   fabIconCubit = fabIcon;
   emit(changeBSheetAndFabState());
 }

 void createDB ()async{
 openDatabase(
   'todoApp.db' ,
   version: 1,
   onCreate: (database , version){
     print("dataBase created");
     database.execute('CREATE TABLE TASKS (id INTEGER PRIMARY KEY, title TEXT , date TEXT , time TEXT , status TEXT )').then((value) =>
     {
        print("DB Table Created")
     });
   },
   onOpen: (database){
     getDB(database);
     print("DB Opened");
 },
 ).then((value) => {
   database = value,
   emit(TodoCreateDB()),
 });
}

  Future insertIntoDB({
    required String time,
    required String title,
    required String date,
  }) async {
    return await database!.transaction((txn) => txn
        .rawInsert(
        'INSERT INTO Tasks (title , date , time , status) VALUES ("${title}" , "${date}" , "${time}" ,"new")')
        .then((value) {
      emit(TodoInsertIntoDB());
      print("$value is inserted");
      getDB(database);
    }).catchError((onError) {
      print("${onError.toString} is detected ");
    }));
  }

  void getDB(database) {
    newTasks = [];
    doneTasks = [];
    archievedTasks = [];

    database.rawQuery('SELECT * FROM Tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archievedTasks.add(element);
        }
      });

      emit(TodoGetFromDB());
    });
  }

  void updateDB({
    required String status,
    required int id,
  }) {
    database!.rawUpdate('UPDATE Tasks SET status = ?  WHERE id = ?  ',
        ['$status', '$id']).then((value) {
      getDB(database);
      emit(TodoUpdateDB());
    });
  }


  void deleteDB({
    required int id,
  }) async
  {
    database!.rawDelete('DELETE FROM Tasks WHERE id = ?', [id])
        .then((value)
    {
      getDB(database);
      emit(TodoDeleteDB());
    });
  }

}