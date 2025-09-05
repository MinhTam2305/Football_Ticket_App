import 'package:flutter/material.dart';
import 'package:football_ticket/models/cart_item_model.dart';
import 'package:football_ticket/services/cart_service.dart';
import 'package:football_ticket/widgets/cart_floating_button.dart';
import 'package:football_ticket/models/user_model.dart';
import 'package:football_ticket/screens/cart/cart_screen.dart';

/// ====== MODELS ======

class Product {
  final String id;
  final String name;
  final int price; // VNĐ
  final String imageUrl;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });
}

/// ====== SCREEN ======

class AccessoryPage extends StatefulWidget {
  const AccessoryPage({
    super.key,
    this.categories = const ['Áo đấu', 'Item', 'Item','Áo đấu', 'Item', 'Item','Áo đấu', 'Item', 'Item'],
    this.products = const [],
    required this.user,
  });

  final List<String> categories;
  final List<Product> products;
  final UserModel user;

  @override
  State<AccessoryPage> createState() => _AccessoryScreenState();
}

class _AccessoryScreenState extends State<AccessoryPage> {
  int _selectedCategory = 0;
  final CartService _cartService = CartService();

  // Dummy data để xem giao diện (sau này bạn truyền từ Firestore/API vào prop `products`)
  List<Product> get _displayProducts =>
      (widget.products.isEmpty ? _mockProducts : widget.products)
          .where((p) => _selectedCategory == 0 ? true : true) // filter sau
          .toList();

  void _addToCart(Product product) {
    final cartItem = CartItem(
      id: product.id,
      type: CartItemType.accessory,
      title: product.name,
      subtitle: 'Phụ kiện',
      imageUrl: product.imageUrl,
      price: product.price.toDouble(),
      quantity: 1,
    );
    
    _cartService.addItem(cartItem);
    
    // Hiển thị thông báo
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã thêm ${product.name} vào giỏ hàng'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Xem giỏ hàng',
          onPressed: () {
            // Navigate to cart screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartScreen(user: widget.user),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            const _Header(title: 'Accessory'),
            const SizedBox(height: 18),
            CategoryFilterBar(
              categories: widget.categories,
              selectedIndex: _selectedCategory,
              onChanged: (i) => setState(() => _selectedCategory = i),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ProductGrid(
                products: _displayProducts,
                onTapProduct: (p) {},
                onAddToCart: _addToCart,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CartFloatingButton(user: widget.user),
    );
  }
}

/// ====== WIDGETS ======

class _Header extends StatelessWidget {
  const _Header({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}

/// Thanh lọc danh mục
class CategoryFilterBar extends StatelessWidget {
  const CategoryFilterBar({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) => _CategoryChip(
          label: categories[i],
          selected: i == selectedIndex,
          onTap: () => onChanged(i),
        ),
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: categories.length,
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final border = RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));
    return Material(
      color: selected ? const Color(0xFFD7E6FF) : Colors.white,
      shape: border,
      child: InkWell(
        onTap: onTap,
        customBorder: border,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFB6C2D2)),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: selected ? const Color(0xFF1A73E8) : const Color(0xFF1F2937),
            ),
          ),
        ),
      ),
    );
  }
}

/// Lưới sản phẩm
class ProductGrid extends StatelessWidget {
  const ProductGrid({
    super.key,
    required this.products,
    required this.onTapProduct,
    required this.onAddToCart,
  });

  final List<Product> products;
  final ValueChanged<Product> onTapProduct;
  final ValueChanged<Product> onAddToCart;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // Tỉ lệ cho giống ảnh chụp màn hình
    final childAspectRatio = width < 400 ? 0.70 : 0.75;

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) {
        final p = products[index];
        return ProductCard(
          product: p,
          onTap: () => onTapProduct(p),
          onAddToCart: () => onAddToCart(p),
        );
      },
    );
  }
}

/// Card sản phẩm (ảnh + giá overlay + tên + nút giỏ)
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAddToCart,
  });

  final Product product;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 0,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Ảnh (có thể thay bằng CachedNetworkImage của bạn)
                    Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const ColoredBox(
                        color: Color(0xFFE5E7EB),
                        child: Center(child: Icon(Icons.image_not_supported)),
                      ),
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const ColoredBox(
                          color: Color(0xFFE5E7EB),
                          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        );
                      },
                    ),
                    // Price tag (góc dưới trái)
                    Positioned(
                      left: 8,
                      bottom: 8,
                      child: PriceTag(price: product.price),
                    ),
                    // Cart button (góc dưới phải)
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: _IconBadgeButton(
                        icon: Icons.shopping_cart_outlined,
                        onTap: onAddToCart,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Tên sản phẩm
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}

/// Huy hiệu hiển thị giá
class PriceTag extends StatelessWidget {
  const PriceTag({super.key, required this.price});
  final int price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFB6C2D2)),
      ),
      child: Text(
        _formatVnCurrency(price),
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

/// Nút tròn nhỏ cho các action trên ảnh
class _IconBadgeButton extends StatelessWidget {
  const _IconBadgeButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 0,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFB6C2D2)),
          ),
          child: Icon(icon, size: 18),
        ),
      ),
    );
  }
}

/// ====== HELPERS & MOCK ======

String _formatVnCurrency(int value) {
  final s = value.toString();
  final buff = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    final idx = s.length - i;
    buff.write(s[i]);
    if (idx > 1 && idx % 3 == 1) buff.write('.');
  }
  return '$buff đ';
}

const _mockProducts = [
  Product(
    id: '1',
    name: 'Áo đấu Việt Nam',
    price: 50000,
    imageUrl:
        'https://images.unsplash.com/photo-1517649763962-0c623066013b?q=80&w=800&auto=format&fit=crop',
  ),
  Product(
    id: '2',
    name: 'Áo đấu Việt Nam',
    price: 50000,
    imageUrl:
        'https://images.unsplash.com/photo-1546519638-68e109498ffc?q=80&w=800&auto=format&fit=crop',
  ),
  Product(
    id: '3',
    name: 'Áo đấu Việt Nam',
    price: 50000,
    imageUrl:
        'https://images.unsplash.com/photo-1519741497674-611481863552?q=80&w=800&auto=format&fit=crop',
  ),
  Product(
    id: '4',
    name: 'Áo đấu Việt Nam',
    price: 50000,
    imageUrl:
        'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?q=80&w=800&auto=format&fit=crop',
  ),
  Product(
    id: '5',
    name: 'Áo đấu Việt Nam',
    price: 50000,
    imageUrl:
        'https://images.unsplash.com/photo-1519683109079-d5f539e15426?q=80&w=800&auto=format&fit=crop',
  ),
  Product(
    id: '6',
    name: 'Áo đấu Việt Nam',
    price: 50000,
    imageUrl:
        'https://images.unsplash.com/photo-1517649763962-0c623066013b?q=80&w=800&auto=format&fit=crop',
  ),
];
