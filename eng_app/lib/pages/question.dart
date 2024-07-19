import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/database.dart';

class Question extends StatefulWidget {
  final String category;
  const Question({required this.category});

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  bool show = false;
  Stream? quizStream;
  PageController controller = PageController();

  @override
  void initState() {
    super.initState();
    loadQuizData();
  }

  loadQuizData() async {
    quizStream = await DatabaseMethods().getCategoryQuiz(widget.category);
    setState(() {});
  }

  Widget buildQuiz() {
    return StreamBuilder(
      stream: quizStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return PageView.builder(
          controller: controller,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return buildQuizCard(ds);
          },
        );
      },
    );
  }

  Widget buildQuizCard(DocumentSnapshot ds) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 40.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                ds["Image"],
                height: 300,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Padding(
            padding: EdgeInsets.only(top: 20.0), // Adjust padding to center question
            child: Text(
              ds["question"], // Display the question
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20.0),
          buildOption(ds, "option1"),
          SizedBox(height: 20.0),
          buildOption(ds, "option2"),
          SizedBox(height: 20.0),
          buildOption(ds, "option3"),
          SizedBox(height: 20.0),
          buildOption(ds, "option4"),
          SizedBox(height: 10.0),
          GestureDetector(
            onTap: () {
              setState(() {
                show = false;
              });
              controller.nextPage(
                duration: Duration(milliseconds: 200),
                curve: Curves.easeIn,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Color(0xFF004840),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOption(DocumentSnapshot ds, String option) {
    return GestureDetector(
      onTap: () {
        setState(() {
          show = true;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(
            color: show && ds["correct"] == ds[option] ? Colors.green : show ? Colors.red : Color(0xFF818181),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          ds[option],
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF004840),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 50.0, left: 20.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Color(0xFFf35b32),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 100.0),
                Text(
                  widget.category,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Expanded(child: buildQuiz()),
        ],
      ),
    );
  }
}
