import 'dart:io';

import 'package:eng_app/Admin/add_quiz.dart';
import 'package:eng_app/pages/home.dart';
import 'package:eng_app/screens/HomePage.dart';
import 'package:eng_app/screens/account_screen.dart';
import 'package:eng_app/screens/search_page.dart';
import 'package:eng_app/screens/translator_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../widget/bnb.dart';
import 'Setting.dart';


class mainPage extends StatefulWidget {
  const mainPage({super.key});

  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
   final ValueNotifier<int> _currentPageIndex = ValueNotifier<int>(4);
   final List<Widget> _pages = [
     AccountScreen(),
     Home(),
     TranslatorScreen(),
     SearchPage(),
     HomeScreen(),
   ];

   @override
   Widget build(BuildContext context) {
     return MaterialApp(
       debugShowCheckedModeBanner: false,
       theme: AppTheme.lightTheme,
       darkTheme: AppTheme.darkTheme,
       themeMode: ThemeMode.system,
       home: Scaffold(
         body: ValueListenableBuilder<int>(
           valueListenable: _currentPageIndex,
           builder: (context, currentIndex, _) {
             return _pages[currentIndex];
           },
         ),
         bottomNavigationBar: AppBBN(
           atBottom: false, // Hoặc điều chỉnh giá trị tùy ý
           onTap: (index) {
             _currentPageIndex.value = index;
           },
         ),
       ),
     );
   }
}
