import 'package:flutter/material.dart';

class Question extends StatefulWidget {
  const Question({super.key});

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0048),
      body: Container(child: Column(children: [
    Row(children: [
      Container(
          decoration: BoxDecoration(color: Color(0xFFf35b32)),
          child: Icon(Icons.arrow_back_ios, color: Colors.white,))
    ],)
      ],),),
    );
  }
}
