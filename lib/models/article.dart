class Article {
  final String title;
  final String description;
  final String url;
  final String? urlToImage;
  final DateTime publishedAt;
  final String sourceName;
  final String? author;
  final String? content;

  Article({
    required this.title,
    required this.description,
    required this.url,
    this.urlToImage,
    required this.publishedAt,
    required this.sourceName,
    this.author,
    this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'],
      publishedAt: DateTime.parse(json['publishedAt']),
      sourceName: json['source']['name'] ?? '',
      author: json['author'],
      content: json['content'],
    );
  }

  static List<Article> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Article.fromJson(json)).toList();
  }
}
