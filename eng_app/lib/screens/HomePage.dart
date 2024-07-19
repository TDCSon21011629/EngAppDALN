import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '';
import '../services/wordnik/wordnik.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String wordOfTheDay = '';
  String definition = '';
  String searchWord = ''; // Từ cần tra cứu
  List<String> searchHistory = []; // Lịch sử tìm kiếm
  List<String> savedWords = []; // Danh sách từ đã lưu

  @override
  void initState() {
    super.initState();
    _loadSavedWords();
    _loadSearchHistory();
    _fetchWordOfTheDay();
  }

  Future<void> _fetchWordOfTheDay() async {
    final response = await wordNikApi.get(word: 'randomWord', params: {});
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        wordOfTheDay = data['word'];
        definition = data['definitions'][0]['text']; // Lấy định nghĩa đầu tiên
      });
    } else {
      // Xử lý lỗi
    }
  }

  Future<void> _searchWord() async {
    if (searchWord.isNotEmpty) {
      final response = await wordNikApi.get(word: searchWord, params: {});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          definition = data['definitions'][0]['text'];
          _addSearchHistory(searchWord);
        });
      } else {
        // Xử lý lỗi
      }
    }
  }

  void _addSearchHistory(String word) {
    setState(() {
      searchHistory.insert(0, word); // Thêm vào đầu danh sách
      _saveSearchHistory();
    });
  }

  Future<void> _saveWord() async {
    if (wordOfTheDay.isNotEmpty && !savedWords.contains(wordOfTheDay)) {
      setState(() {
        savedWords.add(wordOfTheDay);
        _saveSavedWords();
      });
    }
  }

  Future<void> _loadSavedWords() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedWords = prefs.getStringList('savedWords') ?? [];
    });
  }

  Future<void> _saveSavedWords() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('savedWords', savedWords);
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      searchHistory = prefs.getStringList('searchHistory') ?? [];
    });
  }

  Future<void> _saveSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('searchHistory', searchHistory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tra từ điển'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ... (Phần "Từ của ngày" giống như code mẫu trước đó)

            TextField(
              onChanged: (value) => setState(() => searchWord = value),
              decoration: InputDecoration(
                hintText: 'Nhập từ cần tra cứu',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchWord,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text('Định nghĩa: $definition'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveWord,
              child: Text('Lưu từ'),
            ),
            SizedBox(height: 16),
            Text(
              'Từ đã lưu:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: savedWords.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(savedWords[index]),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Lịch sử tìm kiếm:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: searchHistory.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(searchHistory[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
