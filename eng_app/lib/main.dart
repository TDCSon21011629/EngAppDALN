import 'dart:io';

import 'package:eng_app/screens/Setting.dart';
import 'package:eng_app/screens/course_screen.dart';
import 'package:eng_app/screens/home_login_screen.dart';
import 'package:eng_app/screens/home_screen.dart';
import 'package:eng_app/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:eng_app/screens/welcome_screen.dart';
import 'package:eng_app/config/app_theme.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid ?
    await Firebase.initializeApp(
      options:FirebaseOptions(
          apiKey: "AIzaSyD_I8LTksveghTmTCDbAB8YHX8j0MCIryI",
          appId: "1:714749532013:android:175644c4d9e4237d6cac64",
          messagingSenderId: "714749532013",
          projectId: "english-vocabulary-f7a77"
      )
    ): await Firebase.initializeApp();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context,snapshot) {
            if (snapshot.hasData) {
              return HomeScreen();
            }else {
              return LoginScreen();
            }
          },
        ),
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,

        routes: {
          "/Homepage":(context) => HomeScreen(),
          "/Setting" :(context) => Setting(),

        },

    );
  }
}
