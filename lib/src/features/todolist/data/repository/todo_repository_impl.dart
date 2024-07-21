import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/core/error/failure/exceptions.dart';
import 'package:todolist/core/error/failure/failure.dart';
import 'package:todolist/src/features/todolist/data/datasource/local_data_source.dart';
import 'package:todolist/src/features/todolist/domain/entities/todo_item.dart';
import 'package:todolist/src/features/todolist/domain/entities/todo_profile.dart';
import 'package:todolist/src/features/todolist/domain/repository/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource localDataSource;

  TodoRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, bool>> addNewTodoItem(
      {required TodoItemEntity todoItem,
      required TodoProfile todoProfile}) async {
    try {
      List<TodoProfile> todoProfiles = await _getProfiles();
      RxList<TodoItemEntity> items = await _getTodoItemsInProfile(todoProfile);
      items.add(todoItem);
      items.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      TodoProfile newProfile = todoProfile.copyWith(items: items);

      todoProfiles.remove(todoProfile);
      todoProfiles.add(newProfile);

      localDataSource.saveTodoProfiles(profiles: todoProfiles);
      return const Right(true);
    } on Exception catch (_) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> createNewTodoProfile(
      {required String profileName, required Color color}) async {
    print('create todo profile repo impl');
    try {
      List<TodoProfile> todoProfiles = await _getProfiles();
      todoProfiles.add(
          TodoProfile(items: <TodoItemEntity>[].obs, profileName: profileName));
      localDataSource.saveTodoProfiles(profiles: todoProfiles);
      return const Right(true);
    } on Exception catch (_) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTodoItem(
      {required TodoItemEntity todoItem,
      required TodoProfile todoProfile}) async {
    try {
      List<TodoProfile> todoProfiles = await _getProfiles();
      RxList<TodoItemEntity> items = await _getTodoItemsInProfile(todoProfile);
      items.remove(todoItem);
      TodoProfile newProfile = todoProfile.copyWith(items: items);

      todoProfiles.remove(todoProfile);
      todoProfiles.add(newProfile);

      localDataSource.saveTodoProfiles(profiles: todoProfiles);
      return const Right(true);
    } on CacheException catch (_) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTodoProfile(
      TodoProfile todoProfile) async {
    try {
      List<TodoProfile> todoProfiles = await _getProfiles();
      todoProfiles.remove(todoProfile);
      localDataSource.saveTodoProfiles(profiles: todoProfiles);
      return const Right(true);
    } on Exception catch (_) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, RxList<TodoItemEntity>>> getTodoItemsByProfile(
      {required TodoProfile todoProfile}) async {
    try {
      return Right(await _getTodoItemsInProfile(todoProfile));
    } on CacheException catch (_) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<TodoProfile>>> getTodoProfiles() async {
    try {
      return Right(await _getProfiles());
    } on CacheException catch (_) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> changeTodoItemStatus(
      {required TodoItemEntity todoItem,
      required bool isDone,
      required TodoProfile profile}) async {
    try {
      List<TodoProfile> todoProfiles = await _getProfiles();
      RxList<TodoItemEntity> items = await _getTodoItemsInProfile(profile);
      items.remove(todoItem);
      items.add(todoItem.copyWith(isDone: isDone));
      items.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      TodoProfile newProfile = profile.copyWith(items: items);

      todoProfiles.remove(profile);
      todoProfiles.add(newProfile);

      localDataSource.saveTodoProfiles(profiles: todoProfiles);
      return const Right(true);
    } on Exception catch (_) {
      return Left(CacheFailure());
    }
  }

  Future<RxList<TodoItemEntity>> _getTodoItemsInProfile(
      TodoProfile profile) async {
    print("repo impl getitems");
    try {
      final todoProfiles = await _getProfiles();
      if (todoProfiles.isEmpty) {
        throw CacheException();
      }
      RxList<TodoItemEntity> items = profile.items;
      return items;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TodoProfile>> _getProfiles() async {
    print("repo impl get profiles");
    try {
      return (await localDataSource.getTodoProfiles());
    } on CacheException {
      throw CacheException();
    }
  }
}
