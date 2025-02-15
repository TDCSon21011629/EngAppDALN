import 'package:equatable/equatable.dart';
import './related_words.dart';

class WordNikResponse extends Equatable {
  WordNikResponse({
    required this.id,
    required this.partOfSpeech,
    required this.attributionText,
    required this.sourceDictionary,
    required this.text,
    required this.sequence,
    required this.score,
    required this.word,
    required this.relatedWords,
    required this.exampleUses,
    required this.textProns,
    required this.notes,
    required this.attributionUrl,
    required this.wordnikUrl,
  });

  factory WordNikResponse.fromJson(json) {
    return WordNikResponse(
      id: json['id'] as String,
      partOfSpeech: json['partOfSpeech'] as String,
      attributionText: json['attributionText'] as String,
      sourceDictionary: json['sourceDictionary'] as String,
      text: json['text'] as String,
      sequence: json['sequence'] as String,
      word: json['word'] as String,
      attributionUrl: json['attributionUrl'] as String,
      wordnikUrl: json['wordnikUrl'] as String,
      score: json['score'] as int,
      relatedWords: json['relatedWords'] as List<RelatedWords>,
      exampleUses: json['exampleUses'] as List<String>,
      textProns: json['textProns'] as List<String>,
      notes: json['notes'] as List<String>,
    );
  }

  final String id;
  final String partOfSpeech;
  final String attributionText;
  final String sourceDictionary;
  final String text;
  final String sequence;
  final int score;
  final String word;
  final List<RelatedWords> relatedWords;
  final List<String> exampleUses;
  final List<String> textProns;
  final List<String> notes;
  final String attributionUrl;
  final String wordnikUrl;

  List<Object> get props => [
        id,
        partOfSpeech,
        attributionText,
        sourceDictionary,
        text,
        sequence,
        score,
        word,
        relatedWords,
        exampleUses,
        textProns,
        notes,
        attributionUrl,
        wordnikUrl,
      ];
}
