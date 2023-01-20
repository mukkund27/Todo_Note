import 'dart:developer';

import 'package:database_sqflite/Controller/todo_model_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../model/todo_model.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

todoControler _todocontroller = todoControler();

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _titlecontroler = TextEditingController();
  TextEditingController _titleupdatecontroler = TextEditingController();
  TextEditingController _desccontroller = TextEditingController();
  TextEditingController _descupdatecontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TODO APP"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: FutureBuilder<List<TodoModel>>(
          builder:
              (BuildContext context, AsyncSnapshot<List<TodoModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(snapshot.data![index].title),
                    subtitle: Text(snapshot.data![index].desc),
                    trailing: Wrap(
                      children: [
                        IconButton(
                            onPressed: () {
                              _todocontroller
                                  .deleteTodo(snapshot.data![index].id!);
                              setState(() {});
                            },
                            icon: const Icon(Icons.delete)),
                        IconButton(
                            onPressed: () {
                              Get.defaultDialog(
                                  backgroundColor: Colors.white,
                                  barrierDismissible: true,
                                  title: "Update List",
                                  content: Column(
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 220,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: TextFormField(
                                            controller: _titleupdatecontroler,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                labelText: "Title")),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 50,
                                        width: 220,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: TextFormField(
                                            controller: _descupdatecontroller,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                labelText: "Description")),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      MaterialButton(
                                        onPressed: () async {
                                          if (_titleupdatecontroler
                                              .text.isNotEmpty) {
                                            if (_descupdatecontroller
                                                .text.isNotEmpty) {
                                              await _todocontroller.updateTodo(
                                                TodoModel(
                                                    id: snapshot
                                                        .data![index].id,
                                                    title: _titleupdatecontroler
                                                        .text,
                                                    desc: _descupdatecontroller
                                                        .text),
                                              );
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                              Get.back();
                                              _titleupdatecontroler.clear();
                                              _descupdatecontroller.clear();
                                              setState(() {});
                                            } else {
                                              Get.snackbar("Alert",
                                                  "Description is Empty !",
                                                  duration: Duration(
                                                      milliseconds: 800));
                                            }
                                          } else {
                                            Get.snackbar(
                                                "Alert", "Title is Empty !",
                                                duration:
                                                    Duration(milliseconds: 800),
                                                backgroundColor: Colors.red);
                                          }

                                          // Get.offAll(MyHomePage());
                                        },
                                        child: Text(
                                          "Update",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        color: Colors.green.shade500,
                                      )
                                    ],
                                  ));
                            },
                            icon: Icon(Icons.edit)),
                      ],
                    ),
                  );
                },
                itemCount: snapshot.data!.length,
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
          future: _todocontroller.todos(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _todocontroller.todos().then((value) {
            print(value[0].toString());
          });

          Get.defaultDialog(
              backgroundColor: Colors.white,
              barrierDismissible: true,
              title: "Add List",
              content: Column(
                children: [
                  Container(
                    height: 50,
                    width: 220,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                        controller: _titlecontroler,
                        decoration: InputDecoration(
                            border: InputBorder.none, labelText: "Title")),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 50,
                    width: 220,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                        controller: _desccontroller,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Description")),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    color: Colors.blue,
                    onPressed: () {
                      if (_titlecontroler.text.isNotEmpty) {
                        if (_desccontroller.text.isNotEmpty) {
                          _todocontroller.insertTodo(TodoModel(
                              title: _titlecontroler.text.trim(),
                              desc: _desccontroller.text.trim()));
                          Get.back();
                          FocusManager.instance.primaryFocus?.unfocus();
                          _titlecontroler.clear();
                          _desccontroller.clear();
                          setState(() {});
                        } else {
                          Get.snackbar("", "",
                              titleText: Text(
                                "Description is Empty !",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                              duration: Duration(milliseconds: 800),
                              backgroundColor: Colors.red.shade400);
                        }
                      } else {
                        Get.snackbar("", "",
                            titleText: Text(
                              "Title is Empty !",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                            duration: Duration(milliseconds: 800),
                            backgroundColor: Colors.red.shade400);
                      }

                      // Get.offAll(MyHomePage());
                    },
                    child: Text(
                      "Add",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ));
        },
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
