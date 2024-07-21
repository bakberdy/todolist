import 'package:dartz/dartz.dart';
import 'package:todolist/core/usecase/usecase.dart';
import 'package:todolist/src/features/todolist/domain/entities/todo_profile.dart';
import 'package:todolist/src/features/todolist/domain/repository/todo_repository.dart';

import '../../../../../core/error/failure/failure.dart';
import '../entities/todo_item.dart';

class ChangeTodoItemStatus
    extends UseCase<Either<Failure, void>, ChangeTodoItemStatusParams> {
  final TodoRepository repository;

  ChangeTodoItemStatus(this.repository);

  @override
  Future<Either<Failure, void>> call(
      {required ChangeTodoItemStatusParams params}) {
    return repository.changeTodoItemStatus(
      profile: params.profile,
        todoItem: params.todoItem, isDone: params.isDone);
  }
}

class ChangeTodoItemStatusParams {
  final TodoProfile profile;
  final TodoItemEntity todoItem;
  final bool isDone;

  ChangeTodoItemStatusParams(this.profile, {required this.todoItem, required this.isDone});
}
