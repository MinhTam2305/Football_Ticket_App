import 'package:flutter/material.dart';
import 'package:football_ticket/models/accessory_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:football_ticket/core/constants/colors.dart';
import 'package:football_ticket/models/match_details_model.dart';
import 'package:football_ticket/models/stand_model.dart';
import 'package:football_ticket/models/user_model.dart';
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

  // chọn accessory
  final Set<String> _selectedAccessoryIds = {};

  int get _totalAccessory => widget.detailsMatch.accessories
      .where((a) => _selectedAccessoryIds.contains(a.id))
      .fold(0, (sum, a) => sum + a.price);

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
              title: 'Drinking water',
              items: d.accessories,
              selectedIds: _selectedAccessoryIds,
              onToggle:
                  (id) => setState(() {
                    if (_selectedAccessoryIds.contains(id)) {
                      _selectedAccessoryIds.remove(id);
                    } else {
                      _selectedAccessoryIds.add(id);
                    }
                  }),
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

            const SizedBox(height: 80),
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => CartScreen(
                      detailsMatch: widget.detailsMatch,
                      user: widget.user,
                      stand: selectedStand!,
                      totlePrice:
                          (selectedPrice ?? 0) + _totalAccessory.toDouble(),
                      quantity: selectedQuantity ?? 1,
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
                // Text(details.match. ?? 'Stadium', style: AppTextStyles.body1),
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

// --- Accessory grid section ---
class _AccessorySection extends StatelessWidget {
  const _AccessorySection({
    required this.title,
    required this.items,
    required this.selectedIds,
    required this.onToggle,
  });

  final String title;
  final List<AccessoryModel> items;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    // Nếu API chưa có, dùng mock cho phép click
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
            final selected = selectedIds.contains(a.id);
            return Material(
              color: Colors.white,
              child: InkWell(
                onTap: () => onToggle(a.id),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Checkbox(
                          value: selected,
                          onChanged:
                              (_) => onToggle(
                                a.id,
                              ), // phải có onChanged để checkbox hoạt động
                        ),
                      ),
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
                      const SizedBox(height: 8),
                      Text(
                        _formatVnCurrency(a.price),
                        style: AppTextStyles.body1,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
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

class _AccessoryPlaceholderGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemBuilder:
          (_, __) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Checkbox(value: false, onChanged: null),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(color: Colors.grey.shade300),
                  ),
                ),
                const SizedBox(height: 8),
                Text('20 000đ', style: AppTextStyles.body1),
                const SizedBox(height: 6),
              ],
            ),
          ),
    );
  }
}

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
