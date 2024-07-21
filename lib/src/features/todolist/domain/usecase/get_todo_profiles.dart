import 'package:dartz/dartz.dart';
import 'package:todolist/core/error/failure/failure.dart';
import 'package:todolist/core/usecase/usecase.dart';

import '../entities/todo_profile.dart';
import '../repository/todo_repository.dart';

class GetTodoProfiles extends UseCase<Either<Failure, List<TodoProfile>>, NoParams>{
  final TodoRepository repository;

  GetTodoProfiles(this.repository);
  @override
  Future<Either<Failure, List<TodoProfile>>> call({required NoParams params}) {
    return repository.getTodoProfiles();
  }

}