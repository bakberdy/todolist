
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuoteWidget extends StatelessWidget {
  const QuoteWidget({
    super.key,
    required this.themeData,
    required this.quote,
    required this.author,
  });

  final ThemeData themeData;
  final String quote;
  final String author;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: themeData.primaryColor),
      child: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Wrap(children: [
                Text(quote,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp))
              ]),
              Align(
                  alignment: Alignment.centerRight,
                  child: Text(author,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 16.sp)))
            ]),
      ),
    );
  }
}
