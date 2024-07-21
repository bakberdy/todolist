import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:todolist/src/features/todolist/domain/entities/todo_profile.dart';
import 'package:todolist/src/features/todolist/presentation/controller/todo_controller.dart';

import '../screens/todo_profile_screen.dart';

class TodoProfileWidget extends StatelessWidget {
  const TodoProfileWidget(
      {super.key,
      required this.controller,
      required this.index,
      required this.profile});

  final TodoController controller;
  final int index;
  final TodoProfile profile;

  void _confirmDelete(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this profile?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                controller.deleteProfile(index);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile deleted')),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Slidable(
          key: Key(index.toString()),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.25,
            children: [
              SlidableAction(
                onPressed: (context) => _confirmDelete(context, index),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                borderRadius: BorderRadius.circular(12),
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              Get.to(const TodoProfileScreen(), arguments: [profile]);
            },
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 30.h),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 0,
                      blurRadius: 5,
                      color: Colors.grey.withOpacity(0.5))
                ],
                borderRadius: BorderRadius.circular(10.r),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(profile.profileName,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 18.sp)),
                  ),
                  InkWell(
                      onTap: () {},
                      child: const Icon(
                        Icons.chevron_right,
                        color: Colors.black,
                      ))
                ],
              ),
            ),
          )),
    );
  }
}
