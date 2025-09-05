import 'package:flutter/material.dart';
import 'package:football_ticket/services/cart_service.dart';
import 'package:football_ticket/core/constants/colors.dart';
import 'package:football_ticket/screens/cart/cart_screen.dart';
import 'package:football_ticket/models/user_model.dart';

class CartFloatingButton extends StatelessWidget {
  final UserModel user;
  
  const CartFloatingButton({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: CartService(),
      builder: (context, child) {
        final cartService = CartService();
        final itemCount = cartService.totalItems;
        
        return FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartScreen(user: user),
              ),
            );
          },
          backgroundColor: AppColors.primary,
          child: Stack(
            children: [
              const Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              if (itemCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
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
          ),
        );
      },
    );
  }
}
