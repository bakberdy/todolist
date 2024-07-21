import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todolist/src/features/todolist/domain/entities/todo_profile.dart';
import 'package:todolist/src/features/todolist/presentation/controller/todo_controller.dart';
import 'package:todolist/src/features/todolist/presentation/widgets/extended_floating_action_button.dart';
import 'package:todolist/src/features/todolist/presentation/widgets/todo_item_widget.dart';

import '../widgets/submit_button.dart';

class TodoProfileScreen extends StatefulWidget {
  const TodoProfileScreen({super.key});

  @override
  State<TodoProfileScreen> createState() => _TodoProfileScreenState();
}

class _TodoProfileScreenState extends State<TodoProfileScreen> {
  final TodoController controller = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    final TodoProfile todoProfile = Get.arguments[0];
    final themeData = Theme.of(context);
    final items = todoProfile.items;

    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 35,
              )),
          title: Text(
            todoProfile.profileName,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 22.sp),
          ),
        ),
        floatingActionButton: ExtendedFloatingActionButton(
          onPressed: () {
            _showAddTaskBottomSheet(context, todoProfile);
          },
          title: 'Add New Todo',
        ),
        body: items.isEmpty
            ? Center(
                child: Text("Hurry up to create your first ToDo",
                    style: TextStyle(
                        color: themeData.appBarTheme.backgroundColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 18.sp)))
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) => TodoItemWidget(
                    index: index,
                    todoProfile: todoProfile,
                    items: items,
                    controller: controller)));
  }

  void _showAddTaskBottomSheet(BuildContext context, TodoProfile profile) {
    var title = '';
    var task = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        var outlineInputBorder = OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(
            width: 2,
            color: Theme.of(context).primaryColor,
          ),
        );
        var labelStyle = TextStyle(
            height: 1.2,
            fontWeight: FontWeight.w800,
            color: Theme.of(context).primaryColor,
            fontSize: 14.sp);
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "Create New Todo",
                  style: TextStyle(
                      height: 1.2,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).primaryColor,
                      fontSize: 25.sp),
                ),
                SizedBox(
                  height: 20.h,
                ),
                TextField(
                  maxLines: 1,
                  maxLength: 15,
                  onChanged: (val) => title = val,
                  enabled: true,
                  decoration: InputDecoration(
                    enabledBorder: outlineInputBorder,
                    focusedBorder: outlineInputBorder,
                    border: outlineInputBorder,
                    focusColor: Theme.of(context).primaryColor,
                    labelText: 'Task Title',
                    labelStyle: labelStyle,
                  ),
                ),
                SizedBox(height: 10.h),
                TextField(
                  maxLines: 2,
                  maxLength: 60,
                  onChanged: (val) => task = val,
                  decoration: InputDecoration(
                      labelText: 'Task',
                      enabledBorder: outlineInputBorder,
                      focusedBorder: outlineInputBorder,
                      border: outlineInputBorder,
                      labelStyle: labelStyle),
                ),
                SizedBox(height: 20.h),
                SubmitButton(
                    onPressed: () {
                      if (title.length < 3 || task.length < 3) {
                        Get.snackbar(
                            backgroundColor:
                                Theme.of(context).primaryColor.withOpacity(0.5),
                            'Error',
                            'You must fill all fields');
                      } else {
                        Navigator.pop(context);
                        controller.addItem(profile, title, task);
                        setState(() {});
                      }
                    },
                    title: "Add"),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
