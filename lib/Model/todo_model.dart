import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel extends HiveObject {
  @HiveField(0)
  String title;
  @HiveField(1)
  String note;
  @HiveField(2)
  DateTime dueDate;
  @HiveField(3)
  bool isCompleted;

  TodoModel({
    required this.title,
    required this.note,
    required this.dueDate,
    required this.isCompleted,
  });

  TodoModel copyWith({
    String? title,
    String? note,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return TodoModel(
      title: title ?? this.title,
      note: note ?? this.note,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
