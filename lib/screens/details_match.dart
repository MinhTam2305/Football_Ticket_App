import 'package:flutter/material.dart';
import 'package:football_ticket/models/accessory_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:football_ticket/core/constants/colors.dart';
import 'package:football_ticket/models/match_details_model.dart';
import 'package:football_ticket/models/stand_model.dart';
import 'package:football_ticket/models/user_model.dart';
import 'package:football_ticket/models/cart_item_model.dart';
import 'package:football_ticket/services/cart_service.dart';
import 'package:football_ticket/screens/cart/cart_screen.dart';
import 'package:football_ticket/widgets/stands_card.dart';

class DetailsMatch extends StatefulWidget {
  final UserModel user;
  final MatchDetailsModel detailsMatch;
  const DetailsMatch({
    super.key,
    required this.user,
    required this.detailsMatch,
  });

  @override
  State<DetailsMatch> createState() => _DetailsMatchState();
}

class _DetailsMatchState extends State<DetailsMatch> {
  StandModel? selectedStand;
  double? selectedPrice;
  int? selectedQuantity;
  final CartService _cartService = CartService();

  final Map<String, int> _accessoryQty = {};

  int get _totalAccessory {
    final list =
        widget.detailsMatch.accessories.isEmpty
            ? _mockAccessories
            : widget.detailsMatch.accessories;
    int sum = 0;
    for (final a in list) {
      final q = _accessoryQty[a.id] ?? 0;
      sum += q * a.price;
    }
    return sum;
  }

  Future<void> _openMap(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không mở được Google Maps')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.detailsMatch;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        centerTitle: true,
        title: Text("Match details", style: AppTextStyles.title2),
        actions: [
          AnimatedBuilder(
            animation: _cartService,
            builder: (context, child) {
              final itemCount = _cartService.totalItems;
              return Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartScreen(user: widget.user),
                        ),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart, color: Colors.black),
                  ),
                  if (itemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          itemCount > 99 ? '99+' : '$itemCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- Card thông tin trận ---
            _MatchHeaderCard(details: d),

            const SizedBox(height: 25),

            // --- Map từ URL: bấm mở Google Maps ---
            if ((d.mapImageUrl ?? '').isNotEmpty)
              GestureDetector(
                onTap: () {
                  final url = d.mapUrl ?? 'https://maps.google.com';
                  _openMap(url);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      d.mapImageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => Container(
                            color: Colors.grey.shade300,
                            alignment: Alignment.center,
                            child: const Icon(Icons.map_outlined),
                          ),
                      loadingBuilder:
                          (c, child, progress) =>
                              progress == null
                                  ? child
                                  : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                    ),
                  ),
                ),
              )
            else
              // fallback nếu BE không có map
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: AssetImage("assets/images/stadium.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // --- Chọn khán đài ---
            StandsCard(
              stands: d.stand,
              onStandSelected: (stand, price, quantity) {
                setState(() {
                  selectedStand = stand;
                  selectedPrice = price;
                  selectedQuantity = quantity;
                });
              },
            ),

            const SizedBox(height: 16),

            // --- Accessory (Drinking water) ---
            _AccessorySection(
              title: 'Accessory',
              items: d.accessories,
              quantities: _accessoryQty,
              onQtyChanged: (id, qty) {
                setState(() {
                  if (qty <= 0) {
                    _accessoryQty.remove(id);
                  } else {
                    _accessoryQty[id] = qty;
                  }
                });
              },
            ),

            const SizedBox(height: 12),

            // --- Total (vé + accessory) ---
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Total: ${_formatVnCurrency((_selectedPriceInt) + _totalAccessory)} đ',
                style: AppTextStyles.title2,
              ),
            ),

            // const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: GestureDetector(
          onTap: () {
            if (widget.detailsMatch.stand.isEmpty || selectedStand == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Chưa chọn khán đài")),
              );
              return;
            }
            
            // Thêm vé vào cart
            final ticketItem = CartItem(
              id: '${widget.detailsMatch.idMatch}_${selectedStand!.standId}',
              type: CartItemType.ticket,
              title: '${widget.detailsMatch.match.homeTeam.teamName} vs ${widget.detailsMatch.match.awayTeam.teamName}',
              subtitle: 'Stand: ${selectedStand!.standName}',
              imageUrl: widget.detailsMatch.match.homeTeam.logo,
              price: selectedPrice ?? 0,
              quantity: selectedQuantity ?? 1,
              metadata: {
                'matchId': widget.detailsMatch.idMatch,
                'standId': selectedStand!.standId,
                'matchTime': widget.detailsMatch.match.matchTime,
              },
            );
            
            // Thêm accessories được chọn vào cart
            final accessories = <CartItem>[];
            final accessoryList = widget.detailsMatch.accessories.isEmpty 
              ? _mockAccessories 
              : widget.detailsMatch.accessories;
              
            for (final accessory in accessoryList) {
              final qty = _accessoryQty[accessory.id] ?? 0;
              if (qty > 0) {
                accessories.add(CartItem(
                  id: '${widget.detailsMatch.idMatch}_${accessory.id}',
                  type: CartItemType.accessory,
                  title: accessory.name,
                  subtitle: accessory.name,
                  imageUrl: accessory.imageUrl,
                  price: accessory.price.toDouble(),
                  quantity: qty,
                  metadata: {
                    'matchId': widget.detailsMatch.idMatch,
                    'accessoryId': accessory.id,
                  },
                ));
              }
            }
            
            // Thêm tất cả vào cart
            _cartService.addItem(ticketItem);
            for (final accessory in accessories) {
              _cartService.addItem(accessory);
            }
            
            // Hiển thị thông báo
            final totalItems = 1 + accessories.length;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Đã thêm $totalItems items vào giỏ hàng'),
                action: SnackBarAction(
                  label: 'Xem giỏ hàng',
                  onPressed: () {
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
          },
          child: Container(
            height: 55,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                "Add to Cart",
                style: AppTextStyles.title1.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  int get _selectedPriceInt => (selectedPrice ?? 0).round();
}

class _MatchHeaderCard extends StatelessWidget {
  const _MatchHeaderCard({required this.details});
  final MatchDetailsModel details;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 300,
      child: Card(
        color: AppColors.white,
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Image.network(
                      details.match.homeTeam.logo,
                      width: 75,
                      height: 60,
                    ),
                    Text(
                      details.match.homeTeam.teamName,
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Image.network(
                      details.match.awayTeam.logo,
                      width: 75,
                      height: 60,
                    ),
                    Text(
                      details.match.awayTeam.teamName,
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              "VS",
              style: AppTextStyles.title1.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
            Text("V-League 2025 ", style: AppTextStyles.title2),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on_outlined, color: Colors.grey),
                const SizedBox(width: 5),
                Text("Go Dau"),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.date_range_outlined, color: Colors.grey),
                const SizedBox(width: 5),
                Text(details.match.matchDateMY, style: AppTextStyles.body1),
                const SizedBox(width: 15),
                const Icon(Icons.timer_sharp, color: Colors.grey),
                const SizedBox(width: 5),
                Text(details.match.matchTime, style: AppTextStyles.body1),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AccessorySection extends StatelessWidget {
  const _AccessorySection({
    required this.title,
    required this.items,
    required this.quantities,
    required this.onQtyChanged,
  });

  final String title;
  final List<AccessoryModel> items;
  final Map<String, int> quantities;
  final void Function(String id, int qty) onQtyChanged;

  @override
  Widget build(BuildContext context) {
    final list = items.isEmpty ? _mockAccessories : items;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.title2),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: list.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (_, i) {
            final a = list[i];
            final qty = quantities[a.id] ?? 0;
            final selected = qty > 0;

            return Material(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  // toggle nhanh: nếu đang 0 -> 1, nếu >0 -> 0
                  onQtyChanged(a.id, selected ? 0 : 1);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          selected ? AppColors.primary : Colors.blue.shade200,
                      width: selected ? 1.5 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      // Checkbox chọn/bỏ
                      Align(
                        alignment: Alignment.topLeft,
                        child: Checkbox(
                          value: selected,
                          onChanged: (v) {
                            if (v == true) {
                              onQtyChanged(a.id, qty > 0 ? qty : 1);
                            } else {
                              onQtyChanged(a.id, 0);
                            }
                          },
                        ),
                      ),

                      // Ảnh
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Image.network(
                            a.imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder:
                                (_, __, ___) => const Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 48,
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Tên + giá
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            Text(
                              a.name,
                              style: AppTextStyles.body1,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_formatVnCurrency(a.price)} đ',
                              style: AppTextStyles.body1.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Stepper số lượng
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 6,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _QtyBtn(
                              icon: Icons.remove,
                              onTap:
                                  selected && qty > 0
                                      ? () => onQtyChanged(a.id, qty - 1)
                                      : null,
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF6F7FB),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '$qty',
                                style: AppTextStyles.body1.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            _QtyBtn(
                              icon: Icons.add,
                              onTap:
                                  () => onQtyChanged(
                                    a.id,
                                    (qty + 1).clamp(0, 99),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _QtyBtn extends StatelessWidget {
  const _QtyBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: enabled ? AppColors.primary : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: Colors.white),
      ),
    );
  }
}

// Mock cho phép click khi API trống
const _mockAccessories = [
  AccessoryModel(
    id: 'm1',
    name: 'Drinking water',
    price: 20000,
    imageUrl: 'https://images.unsplash.com/photo-1554866585-cd94860890b7?w=640',
    categoryId: "1",
  ),
  AccessoryModel(
    id: 'm2',
    name: 'Drinking water',
    price: 20000,
    imageUrl: 'https://images.unsplash.com/photo-1554866585-cd94860890b7?w=640',
    categoryId: "1",
  ),
  AccessoryModel(
    id: 'm3',
    name: 'Drinking water',
    price: 20000,
    imageUrl: 'https://images.unsplash.com/photo-1554866585-cd94860890b7?w=640',
    categoryId: "1",
  ),
  AccessoryModel(
    id: 'm4',
    name: 'Drinking water',
    price: 20000,
    imageUrl: 'https://images.unsplash.com/photo-1554866585-cd94860890b7?w=640',
    categoryId: "1",
  ),
];

// helper
String _formatVnCurrency(int v) {
  final s = v.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    final idx = s.length - i;
    buf.write(s[i]);
    if (idx > 1 && idx % 3 == 1) buf.write(' ');
  }
  return buf.toString();
}
