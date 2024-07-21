import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todolist/src/features/todolist/domain/entities/quote.dart';
import 'package:todolist/src/features/todolist/domain/entities/todo_item.dart';
import 'package:todolist/src/features/todolist/domain/entities/todo_profile.dart';
import 'package:todolist/src/features/todolist/presentation/controller/todo_controller.dart';
import 'package:todolist/src/features/todolist/presentation/widgets/submit_button.dart';
import 'package:todolist/src/features/todolist/presentation/widgets/todo_profile_widget.dart';

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
                SizedBox(height: 20.h),
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
                              .map((val) => Padding(
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
                                  return TodoProfileWidget(
                                      controller: controller,
                                      index: index,
                                      profile: profile);
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

    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.r),
      borderSide: BorderSide(
        width: 2,
        color: Theme.of(context).primaryColor,
      ),
    );
    Get.bottomSheet(
      isScrollControlled: true,
      Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
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
                    color: Theme.of(context).primaryColor,
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
                  enabledBorder: outlineInputBorder,
                  focusedBorder: outlineInputBorder,
                  border: outlineInputBorder,
                  labelText: 'Profile Name',
                  labelStyle: TextStyle(
                      height: 1.2,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).primaryColor,
                      fontSize: 14.sp),
                ),
              ),
              SizedBox(height: 20.h),
              SubmitButton(
                  onPressed: () {
                    if (value.length < 4) {
                      _showSnackBar('Error',
                          'Profile name must be at least 4 characters long');
                    } else if (controller.profiles.contains(TodoProfile(
                        items: <TodoItemEntity>[].obs, profileName: value))) {
                      _showSnackBar(
                          'Error', 'Profile with this name is already exist');
                    } else {
                      Get.find<TodoController>().createProfile(value);
                      Get.back();
                    }
                  },
                  title: "Add"),
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

  _showSnackBar(String title, String message) {
    Get.snackbar(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
        title,
        message);
  }
}
