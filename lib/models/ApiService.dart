import 'dart:convert';
import 'package:synergy/constants/app_constants.dart';
import 'article.dart';
import 'package:http/http.dart' as http;


class ApiService {
  Future<List<Article>> getArticles() async {
    try {
      final response = await http.get(Uri.parse('${AppConstants.baseUrl}&apiKey=${AppConstants.NEWS_API_KEY}'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);

        List<Article> articles = (json['articles'] as List)
            .map((item) => Article.fromJson(item))
            .toList();

        return articles;
      } else {
        throw Exception('Failed to load articles');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

