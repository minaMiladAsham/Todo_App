import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/components.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';



class DoneTaskScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return BlocConsumer<TodoCubit , TodoStates>(
      listener: (context , state){} ,
      builder: (context , state){
        var tasksList = TodoCubit.get(context).doneTasks;


        if (tasksList.length > 0){

          return ListView.separated(itemBuilder: (context , index) => buildTaskItem(tasksList[index] , context),
            separatorBuilder: (context , index)
            =>  Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container
                (
                height: 1,
                width: double.infinity,
                color: Colors.grey[100],
              ),
            ),
            itemCount: tasksList.length,); }

        else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.menu , size: 80 , color: Colors.grey,),
                Text("Please Insert Some Items" , style: TextStyle(fontSize: 20 , color: Colors.grey))
              ],
            ),
          );
        }
      },
    );

  }



}


