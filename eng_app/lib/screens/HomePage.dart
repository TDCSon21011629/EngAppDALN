import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/database.dart'; // Import DatabaseMethods

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String wordOfTheDay = '';
  String definition = '';
  String pronunciation = '';
  String example = '';
  bool isFavorite = false;
  final FlutterTts flutterTts = FlutterTts();
  List<Map<String, String>> favoriteWords = [];

  final DatabaseMethods databaseMethods = DatabaseMethods();

  @override
  void initState() {
    super.initState();
    _fetchWordOfTheDay();
    _loadFavorites();
  }

  Future<void> _fetchWordOfTheDay() async {
    final response = await http.get(Uri.parse(
        'https://api.wordnik.com/v4/words.json/wordOfTheDay?api_key=0lmnsyr8q2q4ua4ffgff88az1zv3wqpc3t6g3n11zzfdnvbzs'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        wordOfTheDay = data['word'] ?? 'N/A';
        definition = (data['definitions'] != null &&
            data['definitions'].isNotEmpty)
            ? data['definitions'][0]['text'] ?? 'No definition available'
            : 'No definition available';
        pronunciation = (data['pronunciation'] != null &&
            data['pronunciation']['all'] != null)
            ? data['pronunciation']['all'] ?? 'N/A'
            : 'N/A';
        example = (data['examples'] != null && data['examples'].isNotEmpty)
            ? data['examples'][0]['text'] ?? 'No example available'
            : 'No example available';
      });
      _checkIfFavorite();
    } else {
      setState(() {
        wordOfTheDay = 'Error';
        definition = 'Failed to fetch data';
        pronunciation = 'N/A';
        example = 'N/A';
      });
    }
  }

  Future<void> _loadFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      List<Map<String, dynamic>> favorites =
      await databaseMethods.getUserFavorites(user.uid);
      setState(() {
        favoriteWords = favorites
            .map((item) => {
          'word': item['word'].toString(),
          'definition': item['definition'].toString(),
          'example': item['example'].toString()
        })
            .toList();
      });
    }
  }

  Future<void> _checkIfFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      List<Map<String, dynamic>> favorites =
      await databaseMethods.getUserFavorites(user.uid);
      setState(() {
        isFavorite = favorites.any((item) => item['word'] == wordOfTheDay);
      });
    }
  }

  void _playAudio() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.speak(wordOfTheDay);
  }

  void _toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        isFavorite = !isFavorite;
      });
      if (isFavorite) {
        await databaseMethods.addUserFavorite(user.uid, {
          'word': wordOfTheDay,
          'definition': definition,
          'example': example,
        });
      } else {
        await databaseMethods.removeUserFavorite(user.uid, wordOfTheDay);
      }
      _loadFavorites();
    }
  }

  void _showFavoriteWordsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Danh sách yêu thích'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: favoriteWords.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(favoriteWords[index]['word']!),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(favoriteWords[index]['definition']!),
                      SizedBox(height: 5),
                      Text('Example: ${favoriteWords[index]['example'] ?? ''}'),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'EnglishApp',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Word of the Day',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      wordOfTheDay.toUpperCase(),
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      definition,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Example: $example',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontStyle: FontStyle.italic,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pronunciation: $pronunciation',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.blue.shade600,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.volume_up,
                                  color: Colors.blue.shade600),
                              onPressed: _playAudio,
                            ),
                            IconButton(
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.red,
                              ),
                              onPressed: _toggleFavorite,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Danh sách yêu thích',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                TextButton(
                  onPressed: _showFavoriteWordsDialog,
                  child: Text(
                    'Xem thêm',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: favoriteWords.length > 3 ? 3 : favoriteWords.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      favoriteWords[index]['word']!,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    subtitle: Text(
                      favoriteWords[index]['definition']!,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.blue.shade500,
                      ),
                    ),
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
