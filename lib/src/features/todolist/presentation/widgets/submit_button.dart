import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key, required this.onPressed, required this.title});

  final VoidCallback onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor:
                WidgetStatePropertyAll(Theme.of(context).primaryColor),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r)))),
        onPressed: onPressed,
        child: Text(title,
            style: TextStyle(
                height: 1.2,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 18.sp)),
      ),
    );
  }
}
