import 'dart:convert';

import '../../domain/entities/quote.dart';
import 'package:http/http.dart' as http;

abstract class RemoteDataSource {
  Future<List<Quote>> getQuoteList();
}

String url = 'https://zenquotes.io/api/quotes';

class RemoteDataSourceImpl implements RemoteDataSource{
  @override
 Future<List<Quote>> getQuoteList() async {
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((json) => Quote.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load quotes');
  }
}

}