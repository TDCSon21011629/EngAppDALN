import 'package:flutter/material.dart';
import '../services/api.dart';
import '../config/response_model.dart';
import '../widget/bnb.dart';

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
      noDataText = "Meaning cannot be fetched";
    } finally {
      setState(() {
        inProgress = false;
      });
    }
  }
}