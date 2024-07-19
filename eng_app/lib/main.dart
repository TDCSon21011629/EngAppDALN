import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eng_app/screens/main_page.dart';
import 'package:eng_app/screens/translator_screen.dart';
import 'package:eng_app/screens/Setting.dart';

import 'package:eng_app/screens/login.dart';
import 'package:eng_app/screens/search_page.dart';
import 'package:eng_app/config/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyD_I8LTksveghTmTCDbAB8YHX8j0MCIryI",
        appId: "1:714749532013:android:175644c4d9e4237d6cac64",
        messagingSenderId: "714749532013",
        projectId: "english-vocabulary-f7a77",
        storageBucket: "english-vocabulary-f7a77.appspot.com",
      ),
    );
  } else if (Platform.isIOS) {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routes: {
        '/': (context) => StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasData) {
              return mainPage();
            } else {
              return LoginScreen();
            }
          },
        ),
        //'/Homepage': (context) => HomeScreen(),
        '/Setting': (context) => Setting(),
        '/Translator': (context) => TranslatorScreen(),
        '/Dictionary': (context) => SearchPage(),
        '/Login': (context) => LoginScreen(),
      },
    );
  }
}
