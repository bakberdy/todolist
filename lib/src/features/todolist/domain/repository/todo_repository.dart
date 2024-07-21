
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:todolist/src/features/todolist/domain/entities/todo_item.dart';
import 'package:todolist/src/features/todolist/domain/entities/todo_profile.dart';

import '../../../../../core/error/failure/failure.dart';

abstract class TodoRepository {
  Future<Either<Failure, List<TodoItemEntity>>> getTodoItemsByProfile(
      {required TodoProfile todoProfile});
  Future<Either<Failure, List<TodoProfile>>> getTodoProfiles();

  Future<Either<Failure, bool>> deleteTodoItem(
      {required TodoItemEntity todoItem, required TodoProfile todoProfile});

  Future<Either<Failure, bool>> changeTodoItemStatus(
      {required TodoItemEntity todoItem, required bool isDone,required TodoProfile profile});

  Future<Either<Failure, bool>> addNewTodoItem(
      {required TodoItemEntity todoItem, required TodoProfile todoProfile});

  Future<Either<Failure, bool>> createNewTodoProfile({ required String profileName, required Color color});

  Future<Either<Failure, bool>> deleteTodoProfile(TodoProfile todoProfile);
}
