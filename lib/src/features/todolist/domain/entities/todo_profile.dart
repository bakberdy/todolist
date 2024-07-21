import 'package:equatable/equatable.dart';
import 'package:get/get.dart';
import 'package:todolist/src/features/todolist/domain/entities/todo_item.dart';

class TodoProfile extends Equatable {
  final RxList<TodoItemEntity> items;
  final String profileName;

  const TodoProfile({required this.items, required this.profileName});

  @override
  List<Object?> get props => [profileName];

  TodoProfile copyWith({
    RxList<TodoItemEntity>? items,
    String? profileName,
  }) {
    return TodoProfile(
      items: items ?? this.items,
      profileName: profileName ?? this.profileName,
    );
  }

  factory TodoProfile.fromJson(Map<String, dynamic> map) {
    var itemsFromJson = map['items'] as List;
    RxList<TodoItemEntity> itemList = itemsFromJson
        .map((item) => TodoItemEntity.fromJson(item))
        .toList()
        .obs;

    return TodoProfile(
      profileName: map['profileName'],
      items: itemList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profileName': profileName,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  static List<TodoProfile> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => TodoProfile.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<TodoProfile> profiles) {
    return profiles.map((profile) => profile.toJson()).toList();
  }
}
