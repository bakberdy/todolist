import 'package:dartz/dartz.dart';
import 'package:todolist/core/usecase/usecase.dart';
import 'package:todolist/src/features/todolist/domain/entities/todo_item.dart';
import 'package:todolist/src/features/todolist/domain/repository/todo_repository.dart';

import '../../../../../core/error/failure/failure.dart';
import '../entities/todo_profile.dart';

class DeleteTodoItem extends UseCase<Either<Failure, void>, DeleteTodoItemParams>{
  final TodoRepository repository;

  DeleteTodoItem({required this.repository});
  @override
  Future<Either<Failure, void>> call({required DeleteTodoItemParams params}) {
    return repository.deleteTodoItem(todoItem: params.todoItem, todoProfile: params.todoItemProfile);
  }
}

class DeleteTodoItemParams{
  final TodoItemEntity todoItem;
  final TodoProfile todoItemProfile;

  DeleteTodoItemParams({required this.todoItem, required this.todoItemProfile});
}