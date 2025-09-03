// models/accessory.dart
import 'package:equatable/equatable.dart';

class AccessoryModel extends Equatable {
  final String id;
  final String name;
  final int price;        // VNĐ
  final String imageUrl;
  final String categoryId;

  const AccessoryModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.categoryId,
  });

  factory AccessoryModel.fromJson(Map<String, dynamic> j) {
    return AccessoryModel(
      id: j['id'].toString(),
      name: (j['name'] ?? '').toString(),
      price: (j['price'] ?? 0) is String
          ? int.tryParse(j['price']) ?? 0
          : (j['price'] ?? 0) as int,
      imageUrl: (j['imageUrl'] ?? j['image_url'] ?? '').toString(),
      categoryId: (j['categoryId'] ?? j['category_id'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'imageUrl': imageUrl,
        'categoryId': categoryId,
      };

  @override
  List<Object?> get props => [id, name, price, imageUrl, categoryId];
}
