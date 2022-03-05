import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/shared/components.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class TodoHomeScreen extends StatelessWidget {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleFormFieldController = TextEditingController();
  var timeFormFieldController = TextEditingController();
  var dateFormFieldController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:  (BuildContext context) => TodoCubit()..createDB(),
      child: BlocConsumer<TodoCubit , TodoStates>(
        listener: (context , state) {} ,
        builder: (context , state) {
          TodoCubit cubit = TodoCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text("TODO APP" , style: TextStyle(fontSize: 25 , color: Colors.white,),),
              titleSpacing: 20,
            ),
          body: cubit.screens[cubit.bottomNavigationBarCurrentIndex],

          floatingActionButton: FloatingActionButton(
            child: Icon(cubit.fabIconCubit,),
            onPressed: () {
              if(cubit.isBottomSheetOpen){
               if(formKey.currentState!.validate()){
                 cubit.insertIntoDB(
                     title: titleFormFieldController.text ,
                   time:timeFormFieldController.text ,
                   date:dateFormFieldController.text ,
                 );
                 Navigator.pop(context);
                 cubit.changeBSheetAndFab(false, Icons.edit,);
               }
              }
              else {
                cubit.changeBSheetAndFab(true, Icons.add,);
                scaffoldKey.currentState!.showBottomSheet((context)
                => Container(
                  color: Colors.grey[400],
                  width: double.infinity,
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          defaultTextFormField(
                            label: "Task Title",
                            type: TextInputType.text,
                            controller: titleFormFieldController,
                            prefix: Icons.title,
                            validator: (value){
                              if(value!.isEmpty)
                              return "Shouldn\'t Be Empity";
                              else return null;
                            }
                          ),

                        SizedBox(height: 20,),

                        defaultTextFormField(
                          function: (){
                            showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value) =>
                            {
                              timeFormFieldController.text = value!.format(context).toString(),
                            });
                          },
                        label: "Task Time",
                        type: TextInputType.text,
                        controller: timeFormFieldController,
                        prefix: Icons.watch_later_outlined,
                        validator: (value){
                          if(value!.isEmpty)
                            return "Shouldn\'t Be Empity";
                          else return null;
                        }
                         ),

                          SizedBox(height: 20,),

                          defaultTextFormField(
                              function: (){
                               showDatePicker(context: context,
                                   initialDate: DateTime.now(),
                                   firstDate: DateTime.now(),
                                   lastDate: DateTime.parse("2022-01-16"),).then((value) =>
                               {
                                 dateFormFieldController.text = DateFormat.yMMMd().format(value!)
                               });
                              },
                              label: "Task Date",
                              type: TextInputType.text,
                              controller: dateFormFieldController,
                              prefix: Icons.calendar_today,
                              validator: (value){
                                if(value!.isEmpty)
                                  return "Shouldn\'t Be Empity";
                                else return null;
                              }
                          ),


                        ],
                      ),
                    ),
                  ),
                ),
                ).closed.then((value) => {cubit.changeBSheetAndFab(false, Icons.edit,)}) ;

              }
            },
          ),

          bottomNavigationBar: BottomNavigationBar(
          items: [
          BottomNavigationBarItem(icon: Icon(Icons.task),label: "Tasks", ),
          BottomNavigationBarItem(icon: Icon(Icons.done),label: "Done", ),
          BottomNavigationBarItem(icon: Icon(Icons.archive),label: "Archieved", ),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: cubit.bottomNavigationBarCurrentIndex,
          onTap: (index) {cubit.changeBottomNavigationBar(index);},
          ),
          );
        },
      ),
    );

  }
}
