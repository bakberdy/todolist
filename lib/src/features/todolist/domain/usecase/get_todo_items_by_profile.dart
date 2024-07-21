import 'package:dartz/dartz.dart';
import 'package:todolist/core/usecase/usecase.dart';
import 'package:todolist/src/features/todolist/domain/entities/todo_item.dart';
import 'package:todolist/src/features/todolist/domain/entities/todo_profile.dart';
import 'package:todolist/src/features/todolist/domain/repository/todo_repository.dart';

import '../../../../../core/error/failure/failure.dart';

class GetTodoItemsByProfile
    extends UseCase<Either<Failure, List<TodoItemEntity>>, TodoProfile> {
  final TodoRepository repository;

  GetTodoItemsByProfile(this.repository);

  @override
  Future<Either<Failure, List<TodoItemEntity>>> call({required TodoProfile params}) {
    return repository.getTodoItemsByProfile(todoProfile: params);
  }
}
