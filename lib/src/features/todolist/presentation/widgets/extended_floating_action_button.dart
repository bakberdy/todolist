import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExtendedFloatingActionButton extends StatelessWidget {
  const ExtendedFloatingActionButton({super.key, required this.onPressed, required this.title});
  final VoidCallback onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return FloatingActionButton.extended(
          backgroundColor: themeData.primaryColor,
          onPressed: onPressed,
          label: Row(
            children: [
               Icon(
                Icons.add,
                color: Colors.black,
                semanticLabel: title,
              ),
              SizedBox(
                width: 5.w,
              ),
              Text(
                title,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp),
              ),
            ],
          ));
  }
}