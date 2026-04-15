import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:unitcoverter/Model/todo_model.dart';

class TodoDB {
  Box<TodoModel> todosBox;

  TodoDB({required this.todosBox});

  Future<int> addTodo({TodoModel? todo}) async {
    return await todosBox.add(todo!);
  }

  Future<void> editTodo(int? key, TodoModel? todo) async {
    await todosBox.put(key!, todo!);
  }

  Future<void> deleteTodo(TodoModel? todo) async {
    await todo!.delete();
  }

  List<TodoModel> fetchTodos() {
    final todos = todosBox.values.toList();
    todos.sort((a, b) => b.dueDate.compareTo(a.dueDate));
    return todos;
  }

  TodoModel fetchTodoAt(int key) {
    return todosBox.values.firstWhere((todo) => todo.key == key);
  }

  Future<void> toggleComplete(TodoModel todo) async {
    await todosBox.put(todo.key, todo.copyWith(isCompleted: !todo.isCompleted));
  }
}
