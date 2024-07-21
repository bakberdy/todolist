import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todolist/src/features/todolist/domain/entities/todo_profile.dart';
import 'package:todolist/src/features/todolist/presentation/controller/todo_controller.dart';
import 'package:todolist/src/features/todolist/presentation/widgets/extended_floating_action_button.dart';

import '../../domain/entities/todo_item.dart';

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
                itemBuilder: (context, index) => Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.h, vertical: 5.h),
                      child: Container(
                        height: 140,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 0,
                                blurRadius: 3,
                                color: Colors.grey.withOpacity(0.5))
                          ],
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 35.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10.r),
                                    topLeft: Radius.circular(10.r)),
                                color: themeData.primaryColor,
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Icon(
                                    Icons.flag_outlined,
                                    color: Colors.white,
                                    size: 18.sp,
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Task',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14.sp),
                                    ),
                                  ),
                                  _buildOptionsButton(
                                      context, index, todoProfile),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 10.w,
                                ),
                                Icon(
                                  Icons.tag_faces_sharp,
                                  color: Colors.yellow,
                                  size: 30.sp,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  items[index].title,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontSize: 20.sp),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 10.w,
                                ),
                                Expanded(
                                  child: Text(
                                    maxLines: 2,
                                    items[index].task,
                                    style: TextStyle(
                                        height: 1.2,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                        fontSize: 16.sp),
                                  ),
                                ),
                                items[index].isDone
                                    ? Icon(
                                        Icons.task_alt_rounded,
                                        color: Colors.green,
                                        size: 30.sp,
                                      )
                                    : Icon(
                                        Icons.remove_done,
                                        color: Colors.red,
                                        size: 30.sp,
                                      ),
                                SizedBox(
                                  width: 10.w,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )));
  }

  Widget _buildOptionsButton(
      BuildContext context, int index, TodoProfile todoProfile) {
    return PopupMenuButton<String>(
      child: const Icon(
        Icons.more_horiz,
        color: Colors.white,
      ),
      onSelected: (String result) {
        _handleMenuItemClick(result, context, index, todoProfile);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'delete',
          child: Text('Delete'),
        ),
        const PopupMenuItem<String>(
          value: 'done',
          child: Text('Mark as done'),
        ),
        const PopupMenuItem<String>(
          value: 'not_done',
          child: Text('Mark as not done'),
        ),
      ],
    );
  }

  void _handleMenuItemClick(
      String value, BuildContext context, int index, TodoProfile profile) {
    switch (value) {
      case 'delete':
        _showSnackBar(context, 'Item deleted');
        controller.deleteItem(index, profile);
        setState(() {});
        break;
      case 'done':
        _showSnackBar(context, 'Item marked as done!');
        controller.changeItemStatus(index, profile, true);
        setState(() {});
        break;
      case 'not_done':
        _showSnackBar(context, 'Item marked as not done!');
        controller.changeItemStatus(index, profile, false);
        setState(() {});
        break;
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    Get.snackbar(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
        'Item changes',
        message);
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
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                            Theme.of(context).primaryColor),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r)))),
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
                    child: Text(
                      'Add',
                      style: labelStyle.copyWith(
                          color: Colors.white, fontSize: 18.sp),
                    ),
                  ),
                ),
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
