import 'dart:convert';
import '../config/response_model.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';

class API {
  static const String baseUrl =
      "https://api.dictionaryapi.dev/api/v2/entries/en/";

  static Future<ResponseModel> fetchMeaning(String word) async {
    final response = await http.get(Uri.parse("$baseUrl$word"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ResponseModel.fromJson(data[0]);
    } else {
      throw Exception("failed to load meaning");
    }
  }
}

Future<ResponseModel> translateResponseModel(ResponseModel responseModel) async {
  final translator = GoogleTranslator();

  // Dịch word và phonetic
  var translatedWord = await translator.translate(responseModel.word!, to: 'vi');
  responseModel.word = translatedWord.text;
  if (responseModel.phonetic != null) {
    var translatedPhonetic = await translator.translate(responseModel.phonetic!, to: 'vi');
    responseModel.phonetic = translatedPhonetic.text;
  }

  // Dịch meanings
  for (var meaning in responseModel.meanings!) {
    var translatedPartOfSpeech = await translator.translate(meaning.partOfSpeech!, to: 'vi');
    meaning.partOfSpeech = translatedPartOfSpeech.text;
    for (var definition in meaning.definitions!) {
      var translatedDefinition = await translator.translate(definition.definition!, to: 'vi');
      definition.definition = translatedDefinition.text;
      if (definition.example != null) {
        var translatedExample = await translator.translate(definition.example!, to: 'vi');
        definition.example = translatedExample.text;
      }
      // Dịch synonyms và antonyms (nếu có)
      if (definition.synonyms != null && definition.synonyms!.isNotEmpty) {
        definition.synonyms = await Future.wait(definition.synonyms!.map((synonym) => translator.translate(synonym, to: 'vi').then((value) => value.text)));
      }
      if (definition.antonyms != null && definition.antonyms!.isNotEmpty) {
        definition.antonyms = await Future.wait(definition.antonyms!.map((antonym) => translator.translate(antonym, to: 'vi').then((value) => value.text)));
      }
    }
  }

  // Dịch license (nếu có)
  if (responseModel.license != null) {
    var translatedLicenseName = await translator.translate(responseModel.license!.name!, to: 'vi');
    responseModel.license!.name = translatedLicenseName.text;
    var translatedLicenseUrl = await translator.translate(responseModel.license!.url!, to: 'vi');
    responseModel.license!.url = translatedLicenseUrl.text;
  }
  return responseModel;
}