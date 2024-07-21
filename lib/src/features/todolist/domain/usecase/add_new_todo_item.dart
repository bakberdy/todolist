import 'package:dartz/dartz.dart';
import 'package:todolist/core/usecase/usecase.dart';
import 'package:todolist/src/features/todolist/domain/entities/todo_item.dart';
import 'package:todolist/src/features/todolist/domain/entities/todo_profile.dart';
import 'package:todolist/src/features/todolist/domain/repository/todo_repository.dart';

import '../../../../../core/error/failure/failure.dart';

class AddNewTodoItem extends UseCase<Either<Failure, void>, AddNewTodoItemParams>{
  final TodoRepository repository;

  AddNewTodoItem(this.repository);

  @override
  Future<Either<Failure, void>> call({required AddNewTodoItemParams params}) {
    return repository.addNewTodoItem(todoItem: params.todoItem, todoProfile: params.todoProfile);
  }

}

class AddNewTodoItemParams{
  final TodoItemEntity todoItem;
  final TodoProfile todoProfile;

  AddNewTodoItemParams({required this.todoItem, required this.todoProfile});
}