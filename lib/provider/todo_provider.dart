import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';
import 'package:unitcoverter/Model/todo_model.dart';
import 'package:unitcoverter/notifiers/todo_notifier.dart';
import 'package:unitcoverter/service/todo_db.dart';

final todoBoxProvider = Provider<Box<TodoModel>>((ref) {
  return Hive.box<TodoModel>('todos');
});

final todoDBProvider = Provider<TodoDB>((ref) {
  return TodoDB(todosBox: ref.read(todoBoxProvider));
});

final todoNotifierProvider =
    StateNotifierProvider<TodoNotifier, List<TodoModel>>((ref) {
      return TodoNotifier(todoDB: ref.read(todoDBProvider));
    });
