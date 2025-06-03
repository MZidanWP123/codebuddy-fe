import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/news_api_service.dart';
import '../widgets/article_card.dart';
import 'article_detail_screen.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  List<Article> _articles = [];
  bool _isLoading = true;
  String _selectedCategory = 'Latest';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'Latest',
    'AI',
    'Mobile',
    'Web Dev',
    'Blockchain',
    'Cybersecurity',
  ];

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadArticles() async {
    setState(() => _isLoading = true);
    
    try {
      List<Article> articles;
      
      if (_selectedCategory == 'Latest') {
        articles = await NewsApiService.getTechArticles();
      } else {
        articles = await NewsApiService.getArticlesByTopic(
          topic: _getCategoryQuery(_selectedCategory),
        );
      }
      
      setState(() {
        _articles = articles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading articles: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _searchArticles(String query) async {
    if (query.trim().isEmpty) {
      _loadArticles();
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final articles = await NewsApiService.searchTechArticles(query: query);
      setState(() {
        _articles = articles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error searching articles: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _getCategoryQuery(String category) {
    switch (category) {
      case 'AI':
        return 'artificial intelligence machine learning';
      case 'Mobile':
        return 'mobile app development android ios';
      case 'Web Dev':
        return 'web development javascript react';
      case 'Blockchain':
        return 'blockchain cryptocurrency bitcoin';
      case 'Cybersecurity':
        return 'cybersecurity hacking security';
      default:
        return 'technology';
    }
  }

  void _navigateToArticleDetail(Article article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleDetailScreen(article: article),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tech Articles',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D2A44),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Search Bar
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search tech articles...',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: Colors.grey),
                                onPressed: () {
                                  _searchController.clear();
                                  _loadArticles();
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: _searchArticles,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Categories
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final isSelected = category == _selectedCategory;
                        
                        return GestureDetector(
                          onTap: () {
                            setState(() => _selectedCategory = category);
                            _loadArticles();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? const Color(0xFF1D2A44) 
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected 
                                    ? const Color(0xFF1D2A44) 
                                    : Colors.grey[300]!,
                              ),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.grey[600],
                                fontWeight: isSelected 
                                    ? FontWeight.w600 
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            // Articles List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _articles.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.article_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No articles found',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Try searching for different keywords',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadArticles,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _articles.length,
                            itemBuilder: (context, index) {
                              return ArticleCard(
                                article: _articles[index],
                                onTap: () => _navigateToArticleDetail(_articles[index]),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
