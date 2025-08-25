import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class NewsApiService {
  static const String _baseUrl = 'https://newsapi.org/v2';
  static const String _apiKey = '651d0c5bd5dc4a89aa861b73782eca0c'; // Ganti dengan API key Anda
  
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  // Get tech articles
  static Future<List<Article>> getTechArticles({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/top-headlines?category=technology&country=us&page=$page&pageSize=$pageSize&apiKey=$_apiKey'
      );
      
      final response = await http.get(url, headers: _headers);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> articles = data['articles'];
        return Article.listFromJson(articles);
      } else {
        throw Exception('Failed to load articles: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching articles: $e');
    }
  }

  // Search tech articles
  static Future<List<Article>> searchTechArticles({
    required String query,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/everything?q=$query AND technology&sortBy=publishedAt&page=$page&pageSize=$pageSize&apiKey=$_apiKey'
      );
      
      final response = await http.get(url, headers: _headers);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> articles = data['articles'];
        return Article.listFromJson(articles);
      } else {
        throw Exception('Failed to search articles: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching articles: $e');
    }
  }

  // Get articles by specific tech topics
  static Future<List<Article>> getArticlesByTopic({
    required String topic, // e.g., "AI", "blockchain", "mobile development"
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/everything?q=$topic&domains=techcrunch.com,theverge.com,wired.com,arstechnica.com&sortBy=publishedAt&page=$page&pageSize=$pageSize&apiKey=$_apiKey'
      );
      
      final response = await http.get(url, headers: _headers);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> articles = data['articles'];
        return Article.listFromJson(articles);
      } else {
        throw Exception('Failed to load articles: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching articles: $e');
    }
  }
}
