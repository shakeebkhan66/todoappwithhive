import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todoapphive/main.dart';

import 'Model/todo_model.dart';
import 'constant.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

// ToDo Enum TodoFilter
enum TodoFilter{ALL, COMPLETED, INCOMPLETED}

class _HomePageState extends State<HomePage> {
  
  // TODO Instance of ToDo Model
  Box<TodoModel>? todoBox;

  // TODO TextEditingControllers
  TextEditingController titleController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  // ToDo Filter Used
  TodoFilter filter = TodoFilter.ALL;

  
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
        title: Text("A d d   T a s k s", style: TextStyle(color: Constants().backgroundColor1),),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value){
              if(value.compareTo("All") == 0){
                setState(() {
                  filter = TodoFilter.ALL;
                });
              }else if(value.compareTo("Completed") == 0){
               setState(() {
                 filter = TodoFilter.COMPLETED;
               });
              }else{
                setState(() {
                  filter = TodoFilter.INCOMPLETED;
                });
              }
            },
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

      body: Column(
        children: [
          ValueListenableBuilder(
              valueListenable: todoBox!.listenable(),
              builder: (context, Box<TodoModel> todos, _){
                List<int>? keys;

                if(filter == TodoFilter.ALL){
                  keys = todos.keys.cast<int>().toList();
                }else if(filter == TodoFilter.COMPLETED){
                  keys = todos.keys.cast<int>().where((key) => todos.get(key)!.isCompleted).toList();
                }else{
                  keys = todos.keys.cast<int>().where((key) => !todos.get(key)!.isCompleted).toList();
                }

                return Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                      itemCount: keys.length,
                      separatorBuilder: (_, index) => const Divider(),
                    itemBuilder: (BuildContext context, index){

                        final int key = keys![index];
                        final TodoModel? todo = todos.get(key);
                        print(key);

                        return ListTile(
                          title: Text(todo!.title.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
                          subtitle: Text(todo.details.toString(), style: const TextStyle(fontSize: 14),),
                          trailing: Icon(Icons.check_box, color: todo.isCompleted ? Colors.green : Colors.red,),
                          onTap: (){
                            showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  return Dialog(
                                    child: Container(
                                      height: 80,
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 15.0,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              TextButton(
                                                  onPressed: (){
                                                    final TodoModel mTodo = TodoModel(title: todo.title, details: todo.details, isCompleted: true);
                                                    todoBox!.put(key, mTodo);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Completed", style: TextStyle(color: Constants().primaryColor, fontWeight: FontWeight.w700),)
                                              ),
                                              TextButton(
                                                  onPressed: (){
                                                    final TodoModel mTodo = TodoModel(title: todo.title, details: todo.details, isCompleted: false);
                                                    todoBox!.put(key, mTodo);
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("In-completed", style: TextStyle(color: Colors.green, fontWeight: FontWeight.w700),)
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }
                            );
                          },
                        );
                    },
                  ),
                );
              }
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
                            controller: titleController,
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
                            controller: detailController,
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
                            titleController.clear();
                            detailController.clear();
                            Navigator.pop(context);
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
