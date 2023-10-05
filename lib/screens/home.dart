// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:todo_list/constants/colors.dart';
import 'package:todo_list/model/todo.dart';
import 'package:todo_list/widgets/todo_item.dart'; 

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todoList = Todo.todoList(); 
  final todoController = TextEditingController();
  List<Todo> foundTodo = []; 

  @override
  void initState() {
    foundTodo = todoList;
    super.initState(); 
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: lightGreen,
      appBar: buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 50, bottom: 20),
                        child: Text('All To-dos', style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500
                        ),),
                      ),
                      for( Todo todo in foundTodo.reversed)
                        TodoItem(
                          todo: todo,
                          onTodoChanged: handleTodoChange,
                          onDeleteItem: deleteTodoItem,
                        )
                    ]
                  ),
                ), 

              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20, right: 20, left: 20),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [BoxShadow(
                        color: Colors.grey, 
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                        spreadRadius: 0.0)],
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: TextField(
                      controller: todoController,
                      decoration: InputDecoration(
                        hintText: "Add a New Todo Item",
                        border: InputBorder.none
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    bottom: 20, 
                    right: 20
                  ), 
                  child: ElevatedButton(
                    child: Text("+", style:TextStyle(fontSize: 40)),
                    onPressed: () {
                      addTodoItem(todoController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkPink,
                      minimumSize: Size(60, 60),
                      elevation: 10
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      )
    );
  }

  void handleTodoChange(Todo todo) {
    setState(() {
      todo.isDone = !todo.isDone; 
    });
  }

  void deleteTodoItem(String id) {
    setState(() {
      todoList.removeWhere((item) => item.id == id);
    });
  }

  void addTodoItem(String todo) {
    setState(() {
      todoList.add(Todo(id: DateTime.now().millisecondsSinceEpoch.toString(), todoText: todo));
    });

    //clear text field after input
    todoController.clear(); 
  }

  void runFilter(String enteredKeyword){
    List<Todo> results = []; 

    if(enteredKeyword.isEmpty) {
      results = todoList; 
    }
    else {
      results = todoList.where(
        (item) => 
          item.todoText!.toLowerCase().contains(enteredKeyword.toLowerCase())
        ).toList();
    }

    setState(() {
      foundTodo = results; 
    });
  }

  Container searchBox() {
    return Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20)
            ),
            child: TextField(
              onChanged: (value) => {runFilter(value)},
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(0),
                prefixIcon: Icon(Icons.search, color: Colors.black, size: 20),
                prefixIconConstraints: BoxConstraints(maxHeight: 20, minWidth: 25),
                border: InputBorder.none,
                hintText: "Search"
              ),
            ),
          );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.menu, 
            color: Colors.white, 
            size: 30,
          ),
          SizedBox(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Icon(Icons.account_circle)
            ),
          )
      ]),
    );
  }
}