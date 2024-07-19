import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Admin/add_quiz.dart';
import '../pages/question.dart';
import '../services/database.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffedf3f6),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(bottom: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(children: [
                Container(
                  height: 220,
                  padding: EdgeInsets.only(left: 20.0, top: 50.0),
                  decoration: BoxDecoration(
                      color: Color(0xff5e76ff),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "Quizz English",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20)),
                  margin: EdgeInsets.only(top: 120.0, left: 20.0, right: 20.0),
                  child: Row(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20)),
                          child: Image.asset("images/quiz.PNG")),
                      SizedBox(
                        width: 30.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Play &\nWin",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Play Quiz by\nguessing the image",
                            style: TextStyle(
                                color: Color(0xFFa4a4a4),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ]),
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Top Quiz Categories",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddQuiz()),
                        );
                      },
                      child: Text("Create Quiz"),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildCategoryCard(context, "Cấp 1", "images/cap1.jpg"),
                    buildCategoryCard(context, "Cấp 2", "images/cap2.png"),
                  ],
                ),
              ),
              SizedBox(height: 20.0,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildCategoryCard(context, "Cấp 3", "images/cap3.jpg"),
                    buildCategoryCard(context, "Đại học", "images/Daihoc.jpg"),
                  ],
                ),
              ),
              SizedBox(height: 20.0,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildCategoryCard(context, "Yêu thích", "images/favorites.jpg"),
                    buildCategoryCard(context, "Random", "images/random.png"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector buildCategoryCard(BuildContext context, String category, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Question(category: category)));
      },
      child: Material(
        borderRadius: BorderRadius.circular(20),
        elevation: 5.0,
        child: Container(
          width: 150,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20)
          ),
          child: Column(
            children: [
              Image.asset(
                imagePath,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                category,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
