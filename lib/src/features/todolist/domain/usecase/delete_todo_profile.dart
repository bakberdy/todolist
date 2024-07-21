import 'package:dartz/dartz.dart';
import 'package:todolist/core/usecase/usecase.dart';
import 'package:todolist/src/features/todolist/domain/entities/todo_profile.dart';
import 'package:todolist/src/features/todolist/domain/repository/todo_repository.dart';

import '../../../../../core/error/failure/failure.dart';

class DeleteTodoProfile extends UseCase<Either<Failure, void>, TodoProfile>{
  final TodoRepository repository;

  DeleteTodoProfile(this.repository);
  @override
  Future<Either<Failure, void>> call({required TodoProfile params}) {
    return repository.deleteTodoProfile(params);
  }

}