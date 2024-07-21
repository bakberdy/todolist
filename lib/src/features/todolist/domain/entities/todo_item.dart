import 'package:equatable/equatable.dart';

class TodoItemEntity extends Equatable{
  final String title;
  final String task;
  final bool isDone;
  final DateTime createdAt;

  const TodoItemEntity({required this.title, required this.task, this.isDone = false, required this.createdAt});

  @override
  // TODO: implement props
  List<Object?> get props =>[title, task, isDone, createdAt];

  TodoItemEntity copyWith({
    String? title,
    String? task,
    bool? isDone,
    DateTime? createdAt,
  }) {
    return TodoItemEntity(
      title: title ?? this.title,
      task: task ?? this.task,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory TodoItemEntity.fromJson(Map<String, dynamic> map) {
    return TodoItemEntity(
      title: map['title'],
      task: map['task'],
      createdAt: DateTime.parse(map['createdAt']),
      isDone: map['isDone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'task': task,
      'createdAt': createdAt.toIso8601String(),
      'isDone':isDone
    };
  }
}