import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/src/features/todolist/data/datasource/local_data_source.dart';
import 'package:todolist/src/features/todolist/data/datasource/remote_data_source.dart';
import 'package:todolist/src/features/todolist/data/repository/todo_repository_impl.dart';
import 'package:todolist/src/features/todolist/domain/entities/quote.dart';
import 'package:todolist/src/features/todolist/domain/entities/todo_item.dart';
import 'package:todolist/src/features/todolist/domain/entities/todo_profile.dart';
import 'package:todolist/src/features/todolist/domain/repository/todo_repository.dart';

class TodoController extends GetxController {
  late final TodoRepository todoRepository;

  var profiles = <TodoProfile>[].obs;
  RxList<Quote> quotes = <Quote>[].obs;
  RxBool isLoadedQuotes = false.obs;


  @override
  void onInit() async {
    super.onInit();

    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    final TodoLocalDataSource localDataSource = TodoLocalDataSourceImpl(sharedPreferences: sharedPreferences)..initializeTodoProfiles();
    todoRepository = TodoRepositoryImpl(localDataSource: localDataSource);





    await _loadQuotes();

    await _loadProfiles();
  }

  Future<void> _loadQuotes() async {
    final quotesList = await RemoteDataSourceImpl().getQuoteList();
    quotes.assignAll(quotesList);
    isLoadedQuotes.value = true;
  }

  Future<void> _loadProfiles() async {
    final result = await todoRepository.getTodoProfiles();

    result.fold(
      (failure) {
      },
      (profilesList) {
        profiles.addAll(profilesList);
      },
    );
  }

  void deleteProfile(int index) async {
    final profile = profiles[index];
    final result = await todoRepository.deleteTodoProfile(profile);
    result.fold(
      (failure) {
        print('Failed to delete profile: $failure');
      },
      (_) {
        profiles.removeAt(index);
      },
    );
  }

  void createProfile(String name) async {
    final result = await todoRepository.createNewTodoProfile(profileName: name, color: Colors.blue);
    print('create profile controller');
    result.fold(
      (failure) {
        print('Failed to create profile: $failure');
      },
      (_) {
        profiles.add(TodoProfile(items: <TodoItemEntity>[].obs, profileName: name));
      },
    );
  }


  void deleteItem(int index, TodoProfile profile) async {
    final item = profile.items[index];
    await todoRepository.deleteTodoItem(todoItem: item, todoProfile: profile);
  }

  void changeItemStatus(int index, TodoProfile profile, bool isDone) async {
    final item = profile.items[index];
    await todoRepository.changeTodoItemStatus(todoItem: item, isDone: isDone, profile: profile);
  }

  void addItem(TodoProfile profile, String title, String task) async {
    final newItem = TodoItemEntity(
      title: title,
      task: task,
      createdAt: DateTime.now(),
      isDone: false,
    );
    await todoRepository.addNewTodoItem(todoItem: newItem, todoProfile: profile);
  }
}
