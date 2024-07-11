import 'dart:convert';
import 'package:eng_app/dict_data.dart';
import 'package:flutter/material.dart';
import '../widget/app_fader_effect.dart';
import '../widget/bnb.dart';
import 'package:eng_app/main.dart';

class DictionaryScreen extends StatefulWidget {
  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}


class _DictionaryScreenState extends State<DictionaryScreen> {
  bool _atBottom = false;
  int currentPageIndex = 3;

  final Map<String, dynamic> _allWords = jsonDecode(data);
  late List<String> _allKeys;

  @override
  void initState() {
    super.initState();
    _allKeys = _allWords.keys.toList();
  }

  @override
  Widget build(BuildContext context) {
    print(_allWords['abacus']![0]);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Từ Điển'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                setState(() {
                  _allKeys = _allWords.keys
                      .where((key) =>
                          key.toLowerCase().contains(value.toLowerCase()))
                      .toList();
                });
              },
              onSubmitted: (value) {},
              decoration: const InputDecoration(
                  labelText: 'Search', suffixIcon: Icon(Icons.search)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _allKeys.length,
                itemBuilder: (BuildContext context, int index) {
                  final String key = _allKeys[index];
                  return ListTile(
                    title: Text(key),
                    subtitle: Text(_allWords[key][0]),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => DetailView(
                              word: key,
                              definition: _allWords[key][0],
                              pronounce: _allWords[key][1]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBBN(atBottom: _atBottom),
    );
  }
}

class DetailView extends StatelessWidget {
  const DetailView(
      {Key? key,
      required this.word,
      required this.definition,
      required this.pronounce})
      : super(key: key);
  final String word;
  final String definition;
  final String pronounce;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(word),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(word, style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold)),
              Text(pronounce, style: const TextStyle(fontSize: 20)),
              Text(definition, style: const TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
