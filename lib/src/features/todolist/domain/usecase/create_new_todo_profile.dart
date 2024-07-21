import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:todolist/core/usecase/usecase.dart';
import 'package:todolist/src/features/todolist/domain/repository/todo_repository.dart';

import '../../../../../core/error/failure/failure.dart';

class CreateNewTodoProfile
    extends UseCase<Either<Failure, void>, CreateNewTodoProfileParams> {
  final TodoRepository repository;

  CreateNewTodoProfile(this.repository);

  @override
  Future<Either<Failure, void>> call(
      {required CreateNewTodoProfileParams params}) {
    return repository.createNewTodoProfile(
        profileName: params.profileName, color: params.color);
  }
}

class CreateNewTodoProfileParams {
  final String profileName;
  final Color color;

  CreateNewTodoProfileParams({required this.profileName, required this.color});
}
