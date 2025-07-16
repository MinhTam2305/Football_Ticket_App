class NewsItem {
  final int newsId;
  final String title;
  final int? categoryId;
  final String? imageUrl;
  final String content;
  final bool status;
  final String roleType;
  final DateTime createdAt;
  final DateTime? updatedAt;

  NewsItem({
    required this.newsId,
    required this.title,
    this.categoryId,
    this.imageUrl,
    required this.content,
    required this.status,
    required this.roleType,
    required this.createdAt,
    this.updatedAt,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      newsId: json['newsId'],
      title: json['title'],
      categoryId: json['categoryId'],
      imageUrl: json['imageUrl'] != null
          ? "https://intership.hqsolutions.vn${json['imageUrl']}"
          : null,
      content: json['content'],
      status: json['status'],
      roleType: json['roleType'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }
}
