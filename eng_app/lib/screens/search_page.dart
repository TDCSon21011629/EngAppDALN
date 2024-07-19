import 'dart:async';

import 'package:flutter/material.dart';
import '../services/api.dart';
import '../config/response_model.dart';
import '../widget/bnb.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  bool _atBottom = false;
  bool inProgress = false;
  ResponseModel? responseModel;
  String noDataText = "Welcome, Start searching";
  final FlutterTts flutterTts = FlutterTts();
  final StreamController<bool> _inProgressController = StreamController<bool>();
  String? searchQuery;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() {
    flutterTts.setStartHandler(() {
      _inProgressController.add(true);
    });
    flutterTts.setCompletionHandler(() {
      _inProgressController.add(false);
    });
    flutterTts.setErrorHandler((msg) {
      _inProgressController.add(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchWidget(),
                  const SizedBox(height: 12),
                  if (inProgress)
                    const LinearProgressIndicator()
                  else if (responseModel != null)
                    Expanded(child: _buildResponseWidget())
                  else
                    _noDataWidget(),
                ],
              ),
            ),

          )),
    );
  }

  _buildResponseWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          responseModel!.word!,
          style: TextStyle(
            color: Colors.purple.shade600,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),

        Text(responseModel!.phonetic ?? ""),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.volume_up),
              onPressed: () {
                _speak(searchQuery!);
              },
            ),
            IconButton(
              icon: Icon(Icons.favorite_border),
              onPressed: () {
                //_addWordToQuiz(responseModel!);
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return _buildMeaningWidget(responseModel!.meanings![index]);
              },
              itemCount: responseModel!.meanings!.length,
            ))
      ],
    );
  }

  _buildMeaningWidget(Meanings meanings) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meanings.partOfSpeech!,
              style: TextStyle(
                color: Colors.orange.shade600,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Định nghĩa: ",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Column(
              children: meanings.definitions!.map((definition) => Text(definition.definition!)).toList(),
            ),
            _buildSet("Từ đồng nghĩa", meanings.synonyms),
            _buildSet("Từ trái nghĩa", meanings.antonyms),
          ],
        ),
      ),
    );
  }

  _buildSet(String title, List<String>? setList) {
    if (setList?.isNotEmpty ?? false) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Text(setList!.join(", ")), // Nối các phần tử thành chuỗi
          const SizedBox(height: 10),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  _noDataWidget() {
    return SizedBox(
      height: 100,
      child: Center(
        child: Text(
          noDataText,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  _buildSearchWidget() {
    return SearchBar(
      hintText: "Search word here",
      onSubmitted: (value) {
        setState(() {
          searchQuery = value;
        });
        _getMeaningFromApi(value);
      },
    );
  }

  _getMeaningFromApi(String word) async {
    setState(() {
      inProgress = true;
    });
    try {
      responseModel = await API.fetchMeaning(word);
      responseModel = await translateResponseModel(responseModel!);
      setState(() {});
    } catch (e) {
      responseModel = null;
      noDataText = "Không có dữ liệu";
    } finally {
      setState(() {
        inProgress = false;
      });
    }
  }

  void _speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.speak(text);
  }

  /*void _addWordToQuiz(ResponseModel responseModel) {
    // Lấy định nghĩa (meaning) từ responseModel
    String correctAnswer = responseModel.meanings![0].definitions![0].definition!;

    // Lấy 3 từ tiếng Việt ngẫu nhiên (bạn cần tự triển khai hàm này)
    List<String> otherOptions = _getRandomVietnameseWords(3);

    // Tạo câu hỏi và thêm vào cơ sở dữ liệu (bạn cần tự triển khai)
    String question = responseModel.word!;
    List<String> allOptions = [correctAnswer, ...otherOptions];
    allOptions.shuffle();

    // Tạo map chứa câu hỏi và các đáp án
    Map<String, dynamic> quizQuestion = {
      'question': question,
      'options': allOptions,
      'correctAnswer': correctAnswer
    };

    // Gọi hàm thêm câu hỏi vào Firebase (bạn cần tự triển khai hàm này)
    DatabaseMethods().addQuizQuestionToCategory(quizQuestion, "Yêu thích"); // Ví dụ: thêm vào danh mục "Yêu thích"

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã thêm từ vào câu hỏi!')),
    );
  }*/
}