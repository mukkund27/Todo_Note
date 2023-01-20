import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../main.dart';
import '../model/todo_model.dart';

class todoControler {
  Future<void> insertTodo(TodoModel todoModel) async {
    // Get a reference to the database.
    final db = await database;

    await db.insert(
      'todo',
      todoModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TodoModel>> todos() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('todo');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return TodoModel(
        id: maps[i]['id'],
        title: maps[i]['title'],
        desc: maps[i]['desc'],
      );
    });
  }

  Future<void> updateTodo(TodoModel todoModel) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Dog.

    db.query("table", columns: [''], where: 'id=?', whereArgs: [1, 4]);
    await db.update(
      'todo',
      todoModel.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [todoModel.id],
    );
  }

  Future<void> deleteTodo(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'todo',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}
