import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:todolist/src/features/todolist/domain/entities/quote.dart';
import 'package:todolist/src/features/todolist/domain/entities/todo_item.dart';
import 'package:todolist/src/features/todolist/domain/entities/todo_profile.dart';
import 'package:todolist/src/features/todolist/presentation/controller/todo_controller.dart';
import 'package:todolist/src/features/todolist/presentation/screens/todo_profile_screen.dart';

import '../widgets/extended_floating_action_button.dart';
import '../widgets/quote_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TodoController controller = Get.put(TodoController());
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      floatingActionButton: ExtendedFloatingActionButton(
        onPressed: () {
          _showAddProfileBottomSheet();
        },
        title: 'Create Profile',
      ),
      appBar: AppBar(
        title: Text(
          "Home",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 22.sp),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Random Quote',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 20.sp)),
                    TextButton(
                      onPressed: () {
                        pageController.nextPage(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.ease);
                      },
                      child: Text('Next quote',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationStyle: TextDecorationStyle.solid,
                              decorationColor: Colors.blue,
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                Obx(() {
                  if (!controller.isLoadedQuotes.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    List<Quote> quotes = controller.quotes;
                    return SizedBox(
                      height: 140.h,
                      child: PageView(
                          controller: pageController,
                          children: quotes
                              .map((val) =>
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0),
                                child: QuoteWidget(
                                    themeData: themeData,
                                    quote: val.q,
                                    author: val.a),
                              ))
                              .toList()),
                    );
                  }
                }),
                SizedBox(
                  height: 30.h,
                ),
                Text('Task Profiles',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 20.sp)),
                SizedBox(
                  height: 5.h,
                ),
                GetX(
                    init: TodoController(),
                    builder: (controller) {
                      final profiles = controller.profiles;
                      return AnimatedSwitcher(
                        duration: const Duration(seconds: 1),
                        child: profiles.isEmpty
                            ? Center(
                          child: Text(
                              "To create profile click on floating button",
                              style: TextStyle(
                                  color: themeData
                                      .appBarTheme.backgroundColor,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18.sp)),
                        )
                            : ListView.builder(
                            itemCount: profiles.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final profile = profiles[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 10.h),
                                child: Slidable(
                                    key: Key(index.toString()),
                                    endActionPane: ActionPane(
                                      motion: const DrawerMotion(),
                                      extentRatio: 0.25,
                                      children: [
                                        SlidableAction(
                                          onPressed: (context) =>
                                              _confirmDelete(
                                                  context, index),
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(12),
                                          icon: Icons.delete,
                                          label: 'Delete',
                                        ),
                                      ],
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(const TodoProfileScreen(),
                                            arguments: [profile]);
                                      },
                                      borderRadius:
                                      BorderRadius.circular(10.r),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.w,
                                            vertical: 30.h),
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                spreadRadius: 0,
                                                blurRadius: 5,
                                                color: Colors.grey
                                                    .withOpacity(0.5))
                                          ],
                                          borderRadius:
                                          BorderRadius.circular(10.r),
                                          color: Colors.white,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                  profile.profileName,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                      FontWeight.w500,
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
                            }),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddProfileBottomSheet() {
    var value = '';

    Get.bottomSheet(
      isScrollControlled: true,
      Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery
              .of(context)
              .viewInsets
              .bottom,
        ),
        child: Container(
          padding: EdgeInsets.all(16.sp),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 10.h,
              ),
              Text(
                "Create New Profile",
                style: TextStyle(
                    height: 1.2,
                    fontWeight: FontWeight.w800,
                    color: Theme
                        .of(context)
                        .primaryColor,
                    fontSize: 25.sp),
              ),
              SizedBox(
                height: 20.h,
              ),
              TextField(
                maxLines: 2,
                maxLength: 80,
                onChanged: (val) => value = val,
                enabled: true,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(
                      width: 2,
                      color: Theme
                          .of(context)
                          .primaryColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(
                      width: 2,
                      color: Theme
                          .of(context)
                          .primaryColor,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(
                      width: 2,
                      color: Theme
                          .of(context)
                          .primaryColor,
                    ),
                  ),
                  labelText: 'Profile Name',
                  labelStyle: TextStyle(
                      height: 1.2,
                      fontWeight: FontWeight.w800,
                      color: Theme
                          .of(context)
                          .primaryColor,
                      fontSize: 14.sp),
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                    WidgetStatePropertyAll(Theme
                        .of(context)
                        .primaryColor),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r))),
                  ),
                  onPressed: () {
                    if (value.length < 4) {
                      Get.snackbar(
                          backgroundColor:
                          Theme
                              .of(context)
                              .primaryColor
                              .withOpacity(0.5),
                          'Error',
                          'Profile name must be at least 4 characters long');
                    } else if (
                    controller.profiles.contains(TodoProfile(
                        items: <TodoItemEntity>[].obs, profileName: value))) {
                      Get.snackbar(
                          backgroundColor:
                          Theme
                              .of(context)
                              .primaryColor
                              .withOpacity(0.5),
                          'Error',
                          'Profile with this name already exist');
                    } else {
                    Get.find<TodoController>().createProfile(value);
                    Get.back();
                    }
                  },
                  child: Text(
                    'Add',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.5),
      isDismissible: true,
      enableDrag: true,
    );
  }

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
}
