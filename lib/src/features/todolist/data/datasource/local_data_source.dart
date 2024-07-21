import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/error/failure/failure.dart';
import '../../domain/entities/todo_profile.dart';

abstract class TodoLocalDataSource {
  Future<List<TodoProfile>> getTodoProfiles();
  Future<void> saveTodoProfiles({required List<TodoProfile> profiles});
  Future<void> initializeTodoProfiles();
}

const CACHED_TASKS = "cachedTasks";

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final SharedPreferences sharedPreferences;

  TodoLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<TodoProfile>> getTodoProfiles() async {
    try {
      final jsonString = sharedPreferences.getString(CACHED_TASKS);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.map((json) => TodoProfile.fromJson(json)).toList();
      } else {
        throw CacheFailure();
      }
    } catch (e) {
      print("Error retrieving todo profiles: $e");
      throw CacheFailure();
    }
  }

  @override
  Future<void> saveTodoProfiles({required List<TodoProfile> profiles}) async {
    try {
      final List<Map<String, dynamic>> jsonList = profiles.map((profile) => profile.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await sharedPreferences.setString(CACHED_TASKS, jsonString);
    } catch (e) {
      print("Error saving todo profiles: $e");
      throw CacheFailure();
    }
  }

  @override
  Future<void> initializeTodoProfiles() async {
    try {
      final jsonString = sharedPreferences.getString(CACHED_TASKS);
      if (jsonString == null || jsonString.isEmpty) {
        await sharedPreferences.setString(CACHED_TASKS, jsonEncode([]));
      }
    } catch (e) {
      print("Error initializing todo profiles: $e");
      throw CacheFailure();
    }
  }
}
