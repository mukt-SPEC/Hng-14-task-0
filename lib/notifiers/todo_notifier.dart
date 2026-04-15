
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:unitcoverter/Model/todo_model.dart';
import 'package:unitcoverter/service/todo_db.dart';

class TodoNotifier extends StateNotifier<List<TodoModel>> {
  final TodoDB todoDB;
  TodoNotifier({required this.todoDB}) : super([]) {
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    final todos = todoDB.fetchTodos();
    state = todos;
  }

  Future<void> addTodo({TodoModel? todo}) async {
    await todoDB.addTodo(todo: todo);
    await fetchTodos();
  }

  Future<void> editTodo(int? key, TodoModel? todo) async {
    await todoDB.editTodo(key, todo);
    await fetchTodos();
  }

  Future<void> deleteTodo(TodoModel? todo) async {
    await todoDB.deleteTodo(todo);
    await fetchTodos();
  }

  Future<void> toggleComplete(TodoModel todo) async {
    await todoDB.toggleComplete(todo);
    await fetchTodos();
  }
}