import 'dart:convert';
import 'package:synergy/constants/app_constants.dart';
import 'package:synergy/models/organization.dart';
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

  Future<List<Organization>> getOrganizations() async {
    try {
      final response = await http.get(Uri.parse('https://pastebin.com/raw/5bdAFy4B'));
      if (response.statusCode == 200) {
        final dynamic jsonResponse = jsonDecode(response.body);
        if (jsonResponse != null && jsonResponse is Map<String, dynamic>) {
          final List<dynamic> jsonList = jsonResponse['organizations'];
          if (jsonList is List<dynamic>) {
            List<Organization> organizations = jsonList
                .map((item) => Organization.fromJson(item))
                .toList();
            return organizations;
          } else {
            throw Exception('Invalid JSON structure - organizations list not found');
          }
        } else {
          throw Exception('Invalid JSON structure - root map not found');
        }
      } else {
        throw Exception('Failed to load organizations');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

