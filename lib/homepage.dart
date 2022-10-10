import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todoapphive/main.dart';

import 'Model/todo_model.dart';
import 'constant.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  // TODO Instance of ToDo Model
  Box<TodoModel>? todoBox;

  // TODO TextEditingControllers
  TextEditingController titleController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  
  @override
  void initState() {
    todoBox = Hive.box<TodoModel>(todoBoxName);
    super.initState();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants().backgroundColor1,
      appBar: AppBar(
        backgroundColor: Constants().primaryColor,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value){},
            itemBuilder: (BuildContext context){
              return ["All", "Completed", "Incompleted"].map((e) {
                return PopupMenuItem(
                  value: e,
                  child: Text(e, style: TextStyle(color: Constants().primaryColor, fontWeight: FontWeight.bold),),
                );
              }).toList();
            },
          )
        ],
      ),

      // ToDo Floating Action Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constants().primaryColor,
        splashColor: Constants().backgroundColor1,
        onPressed: (){
          showDialog(
              context: context,
              builder: (BuildContext context){
                return Dialog(
                  child: Container(
                    height: 230,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                          child: TextFormField(
                            cursorColor: Constants().primaryColor,
                            decoration: InputDecoration(
                              hintText: "Enter Title",
                              labelText: "Title",
                              labelStyle: TextStyle(color: Constants().primaryColor, fontWeight: FontWeight.bold),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Constants().primaryColor),
                                )
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                          child: TextFormField(
                            cursorColor: Constants().primaryColor,
                            decoration: InputDecoration(
                              hintText: "Enter Details",
                              labelText: "Details",
                              labelStyle: TextStyle(color: Constants().primaryColor, fontWeight: FontWeight.bold),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Constants().primaryColor),
                              )
                            ),
                          ),
                        ),
                        const SizedBox(height: 15.0,),
                        MaterialButton(
                          minWidth: 150,
                          splashColor: Constants().backgroundColor1,
                          onPressed: (){

                            String title = titleController.text;
                            String details = detailController.text;

                            // ToDo Add Data in Model and then add in database
                            TodoModel todoModel = TodoModel(title: title, details: details, isCompleted: false);
                            todoBox!.add(todoModel);

                          },
                          color: Constants().primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text("A D D", style: TextStyle(color: Constants().backgroundColor1),),
                        )
                      ],
                    ),
                  ),
                );
              }
          );
        },
        child: Icon(Icons.add, size: 30, color: Constants().backgroundColor1,),
      ),
    );
  }
}
