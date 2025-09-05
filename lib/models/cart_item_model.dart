enum CartItemType { ticket, accessory }

class CartItem {
  final String id;
  final CartItemType type;
  final String title;
  final String subtitle;
  final String imageUrl;
  final double price;
  final int quantity;
  final Map<String, dynamic> metadata; // Lưu thông tin bổ sung

  const CartItem({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    this.metadata = const {},
  });

  CartItem copyWith({
    String? id,
    CartItemType? type,
    String? title,
    String? subtitle,
    String? imageUrl,
    double? price,
    int? quantity,
    Map<String, dynamic>? metadata,
  }) {
    return CartItem(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      metadata: metadata ?? this.metadata,
    );
  }

  double get totalPrice => price * quantity;
}
