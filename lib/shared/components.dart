import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cubit/cubit.dart';


Widget defaultTextFormField ({
  TextEditingController? controller,
  FormFieldValidator<String>? validator,
  TextInputType? type,
  String? label,
  IconData? prefix,
  GestureTapCallback? function,
}) => TextFormField(
    controller: controller ,
  keyboardType: type,
  validator: validator,
  onTap: function,
  decoration: InputDecoration(
    labelText: label,
    prefixIcon: Icon(prefix),
    border: OutlineInputBorder(),
  ),

    );

Widget buildTaskItem(tasksList , context){
  return Dismissible(
    key: Key(tasksList['id'].toString()),
    onDismissed: (Direction){TodoCubit.get(context).deleteDB(id: tasksList['id'],);},
    background: Container(color: Colors.red,),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text('${tasksList["time"]}',),
          ),
          SizedBox(width: 20,),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${tasksList["title"]}', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
              SizedBox(height: 5,),
              Text('${tasksList["date"]}'),
            ],
          ),
          SizedBox(width: 40,),
          Row(
            children: [
              IconButton(icon: Icon(Icons.check_box_outline_blank),
                onPressed: () {
                  TodoCubit.get(context).updateDB(status: "done", id: tasksList['id']);
                },
                color: Colors.blue,),
              SizedBox(width: 10,),
              IconButton(icon: Icon(Icons.archive_outlined),
                onPressed: () {
                  TodoCubit.get(context).updateDB(status: "archieved", id: tasksList['id']);
                },
                color: Colors.blue,),
            ],
          ),
        ],
      ),
    ),
  );
}