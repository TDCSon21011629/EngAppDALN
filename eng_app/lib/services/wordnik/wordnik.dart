import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;


class _WordNikApi {
  Future<http.Response> get({
    required String word,
    required Map<String, dynamic> params,
  }) async {
    if (params == null) params = {};
    params['api_key'] = dotenv.env['WORDNIK_API_KEY'];
    final url = _getUrl(path: word, params: params);
    log('URL is: $url');
    return http.get(
      url,
    );
  }

  Uri _getUrl({path, Map<String, dynamic> params = const {}}) {
    var url = """
${'https://api.wordnik.com/v4/word.json/'}$path?api_key=0lmnsyr8q2q4ua4ffgff88az1zv3wqpc3t6g3n11zzfdnvbzs${_paramsToQueryString(params: params)}""";

    return Uri.parse(url);
  }

  String _paramsToQueryString({
    required Map<String, dynamic> params,
    String prefix = '',
  }) {
    var segments = <String>[];
    if (params == null) return prefix;

    params.forEach(
      (String key, dynamic value) {
        var queryKey = prefix.isNotEmpty ? '$prefix[$key]' : key;
        if (value is String || value is num || value is DateTime) {
          segments.add('$queryKey=$value');
        }
        if (value is Map) {
          segments.add(_paramsToQueryString(
              params: value as Map<String, dynamic>, prefix: queryKey));
        }
      },
    );
    return segments.join('&');
  }
}

final wordNikApi = _WordNikApi();
