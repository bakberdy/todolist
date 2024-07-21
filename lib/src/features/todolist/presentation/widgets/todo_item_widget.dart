import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todolist/src/features/todolist/domain/entities/todo_profile.dart';
import 'package:todolist/src/features/todolist/presentation/controller/todo_controller.dart';

import '../../domain/entities/todo_item.dart';

class TodoItemWidget extends StatefulWidget {
  const TodoItemWidget({super.key, required this.index, required this.todoProfile, required this.items, required this.controller});

  final int index;
  final TodoProfile todoProfile;
  final List<TodoItemEntity> items;
  final TodoController controller;

  @override
  State<TodoItemWidget> createState() => _TodoItemWidgetState();
}

class _TodoItemWidgetState extends State<TodoItemWidget> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    if(widget.items.isEmpty){
      return const SizedBox();
    }
    else {
      return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 5.h),
      child: Container(
        height: 140.h,
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
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    ),
                  ),
                  _buildOptionsButton(context, widget.index, widget.todoProfile),
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
                  widget.items[widget.index].title,
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
                    widget.items[widget.index].task,
                    style: TextStyle(
                        height: 1.2,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                        fontSize: 16.sp),
                  ),
                ),
                widget.items[widget.index].isDone
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
    );
    }
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
        widget.controller.deleteItem(index, profile);
        setState(() {});
        break;
      case 'done':
        _showSnackBar(context, 'Item marked as done!');
        widget.controller.changeItemStatus(index, profile, true);
        setState(() {});
        break;
      case 'not_done':
        _showSnackBar(context, 'Item marked as not done!');
        widget.controller.changeItemStatus(index, profile, false);
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
}
