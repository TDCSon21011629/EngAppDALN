import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:eng_app/model/dictionary.dart';
import 'package:eng_app/services/api/owl_bot_api.dart';

///gets meaning of word from Owlbot Api

class Meaning {
  Future<Dictionary> getMeaning({@required String word}) async {
    log('@getting meaning for $word');
    final meaningResponse = await owlbotApi.get(word: word);
    try {
      final meaning = Dictionary.fromJson(jsonDecode(meaningResponse.body));

      return meaning;
    } on Exception catch (e) {
      log('@Error in getting meaning: $e');
      return null;
    }
  }
}