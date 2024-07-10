import 'package:eng_app/screens/Setting.dart';
import 'package:eng_app/screens/course_screen.dart';
import 'package:eng_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:eng_app/screens/welcome_screen.dart';
import 'package:eng_app/config/app_theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: "/",
        routes: {
          "/" :(context)=> WelcomeScreen(),
          "/Homepage":(context) => HomeScreen(),
          "/Setting" :(context) => Setting(),

        },

    );
  }
}
