import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todolist/src/features/todolist/presentation/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo app',
        theme: ThemeData(
          primaryColor: const Color(0xff7777FF),
          appBarTheme: const AppBarTheme(color:  Color(0xff000096)),
          useMaterial3: true,
          secondaryHeaderColor: const Color(0xff000096)
        ),
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: ()=> const SplashScreen()),
        ],
      ),
    );
  }
}