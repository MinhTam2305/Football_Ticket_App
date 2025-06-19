import 'package:flutter/material.dart';
import '/screens/cart/cart_successful_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        centerTitle: true,
        title: const Text(
          'Cart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Card trận đấu
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cờ và tên đội
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/vietnamFlag.jpg',
                        width: 60,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'VS',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Image.asset(
                        'assets/images/malaysia.png',
                        width: 60,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Viet Nam',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 40),
                      Text(
                        'Malaysia',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Thông tin trận đấu
                  const Row(
                    children: [
                      Icon(Icons.access_time_outlined, size: 20),
                      SizedBox(width: 8),
                      Text('CN, 8 Th6, 2025 - 8:00'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 20),
                      SizedBox(width: 8),
                      Text('Go Dau'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Stand: A'),
                  const Text('Remaining Tickets: 100'),
                  const SizedBox(height: 12),
                  // Hình ảnh sân vận động
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/stadium.png',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Quantity & Price
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quantity:',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '1',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Price:',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '500.000đ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Spacer(),
            // Nút Payment
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartSuccessfulScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Payment',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}