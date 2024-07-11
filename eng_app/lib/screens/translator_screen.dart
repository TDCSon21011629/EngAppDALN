import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:translator/translator.dart';
import '../widget/app_fader_effect.dart';
import '../widget/bnb.dart';

class TranslatorScreen extends StatefulWidget {
  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  bool _atBottom = false;
  int currentPageIndex = 2;

  final outputController = TextEditingController(text: "Bản dịch...");
  final translator = GoogleTranslator();

  String inputText = '';
  String inputLanguage = 'en';
  String outputLanguage = 'vi';

  Future<void> translateText() async {
    final translated = await translator.translate(inputText,
        from: inputLanguage, to: outputLanguage);
    setState(() {
      outputController.text = translated.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Image.asset(
                  "images/yay.png",
                  fit: BoxFit.contain,
                  height: 240,
                ),
                TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Nhập văn bản cần dịch",
                  ),
                  onChanged: (value) {
                    setState(() {
                      inputText = value;
                    });
                  },
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DropdownButton<String>(
                      value: inputLanguage,
                      onChanged: (newValue) {
                        setState(() {
                          inputLanguage = newValue!;
                        });
                      },
                      items: <String>[
                        'en',
                        'vi',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    Icon(Icons.arrow_forward_rounded),
                    DropdownButton<String>(
                      value: outputLanguage,
                      onChanged: (newValue) {
                        setState(() {
                          outputLanguage = newValue!;
                        });
                      },
                      items: <String>[
                        'en',
                        'vi',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: translateText,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 21, 33, 255),
                    foregroundColor: Colors.white,
                    minimumSize: Size.fromHeight(55),
                  ),
                  child: Text("Dịch"),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: outputController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      inputText = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AppBBN(atBottom: _atBottom),
    );
  }
}
