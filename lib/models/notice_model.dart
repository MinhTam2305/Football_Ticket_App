class NoticeModel {
  final int newsId;
  final String title;
  final String imageUrl;
  final String content;
  final bool status;
  final String roleType;
  final int categoryId;
  final String categoryName;
  final DateTime createdAt;
  final DateTime updatedAt;
  bool opened;

  NoticeModel({
    required this.newsId,
    required this.title,
    required this.imageUrl,
    required this.content,
    required this.status,
    required this.roleType,
    required this.categoryId,
    required this.categoryName,
    required this.createdAt,
    required this.updatedAt,
    this.opened = false,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      newsId: json['newsId'],
      title: json['title'],
      imageUrl: json['imageUrl'],
      content: json['content'],
      status: json['status'],
      roleType: json['roleType'],
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      opened: json['opened'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'newsId': newsId,
      'title': title,
      'imageUrl': imageUrl,
      'content': content,
      'status': status,
      'roleType': roleType,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'opened': opened,
    };
  }
}
