import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_ticket/blocs/payment/payment_bloc.dart';
import 'package:football_ticket/blocs/payment/payment_event.dart';
import 'package:football_ticket/blocs/payment/payment_state.dart';
import 'package:football_ticket/core/constants/colors.dart';
import 'package:football_ticket/models/discount_code_model.dart';
import 'package:football_ticket/models/match_details_model.dart';
import 'package:football_ticket/models/stand_model.dart';
import 'package:football_ticket/models/user_model.dart';
import 'package:football_ticket/models/cart_item_model.dart';
import 'package:football_ticket/services/cart_service.dart';
import 'package:football_ticket/screens/payment/webview_payment_screen.dart';
import 'package:football_ticket/screens/cart/cart_successful_screen.dart';

class CartScreen extends StatefulWidget {
  final MatchDetailsModel? detailsMatch;
  final UserModel user;
  final StandModel? stand;
  final double? totlePrice;
  final int? quantity;

  const CartScreen({
    super.key,
    this.detailsMatch,
    required this.user,
    this.stand,
    this.totlePrice,
    this.quantity,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();
  
  // ====== Mock danh sách mã giảm giá ======
  final List<DiscountCodeModel> _codes = const [
    DiscountCodeModel(
      id: "123",
      code: 'SAVE10',
      title: 'Giảm 10%',
      description: 'Áp dụng cho mọi đơn, tối đa 50.000đ',
      value: 10,
      isPercent: true,
      maxDiscount: 50000,
    ),
    DiscountCodeModel(
      id: "456",
      code: 'FLAT20K',
      title: 'Giảm thẳng 20.000đ',
      description: 'Không yêu cầu đơn tối thiểu',
      value: 20000,
      isPercent: false,
    ),
    DiscountCodeModel(
      id: "789",
      code: 'VIP15',
      title: 'Giảm 15%',
      description: 'Đơn từ 300.000đ trở lên',
      value: 15,
      isPercent: true,
      minOrder: 300000,
      maxDiscount: 80000,
    ),
  ];

  @override
  void initState() {
    super.initState();
    
    // Nếu có thông tin vé được truyền vào, thêm vào cart
    if (widget.detailsMatch != null && 
        widget.stand != null && 
        widget.totlePrice != null && 
        widget.quantity != null) {
      final ticketItem = CartItem(
        id: '${widget.detailsMatch!.idMatch}_${widget.stand!.standId}',
        type: CartItemType.ticket,
        title: '${widget.detailsMatch!.match.homeTeam.teamName} vs ${widget.detailsMatch!.match.awayTeam.teamName}',
        subtitle: 'Stand: ${widget.stand!.standName}',
        imageUrl: widget.detailsMatch!.match.homeTeam.logo,
        price: widget.totlePrice! / widget.quantity!,
        quantity: widget.quantity!,
        metadata: {
          'matchId': widget.detailsMatch!.idMatch,
          'standId': widget.stand!.standId,
          'matchTime': widget.detailsMatch!.match.matchTime,
        },
      );
      
      // Kiểm tra xem item đã có trong cart chưa
      if (!_cartService.hasItem(ticketItem.id, CartItemType.ticket)) {
        _cartService.addItem(ticketItem);
      }
    }
  }

  String _formatVND(num value) {
    final s = value.toStringAsFixed(0);
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      buf.write(s[i]);
      final remain = s.length - i - 1;
      if (remain > 0 && remain % 3 == 0) buf.write('.');
    }
    return '${buf.toString()}đ';
  }

  Future<void> _openDiscountPicker() async {
    DiscountCodeModel? picked = _cartService.selectedDiscountCode;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, modalSetState) {
            final subTotal = _cartService.subtotal;

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 5,
                      width: 48,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const Text(
                      'Chọn mã giảm giá',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textMain,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: _codes.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (_, i) {
                          final c = _codes[i];
                          final canApply = c.calcDiscount(subTotal) > 0;

                          return RadioListTile<DiscountCodeModel>(
                            value: c,
                            groupValue: picked,
                            onChanged:
                                canApply
                                    ? (val) {
                                      modalSetState(() {
                                        picked = val;
                                      });
                                    }
                                    : null,
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${c.title} • ${c.code}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color:
                                          canApply
                                              ? AppColors.textMain
                                              : Colors.grey,
                                    ),
                                  ),
                                ),
                                if (!canApply)
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Chip(
                                      label: Text(
                                        'Không đủ điều kiện',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            subtitle: Text(
                              c.description,
                              style: const TextStyle(color: AppColors.textSub),
                            ),
                            secondary:
                                canApply
                                    ? Text(
                                      '-${_formatVND(c.calcDiscount(subTotal))}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                    : null,
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              picked = null;
                              Navigator.pop(ctx);
                            },
                            child: const Text('Bỏ áp dụng'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                            onPressed: () {
                              _cartService.setDiscountCode(picked);
                              Navigator.pop(ctx);
                            },
                            child: const Text(
                              'Xác nhận',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const BackButton(color: AppColors.textMain),
        centerTitle: true,
        title: const Text(
          "Cart",
          style: TextStyle(
            color: AppColors.textMain,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: _cartService,
        builder: (context, child) {
          final cartItems = _cartService.items;
          
          if (cartItems.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Giỏ hàng trống',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ====== Danh sách items trong cart ======
                      ...cartItems.map((item) => _buildCartItem(item)),
                      
                      const SizedBox(height: 16),

                      // ====== Chọn mã giảm giá ======
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black12),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.local_offer_outlined,
                                  color: AppColors.textMain,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                const Expanded(
                                  child: Text(
                                    'Mã giảm giá',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: AppColors.textMain,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: _openDiscountPicker,
                                  child: const Text('Chọn mã'),
                                ),
                              ],
                            ),
                            if (_cartService.selectedDiscountCode != null) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF6F7FB),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${_cartService.selectedDiscountCode!.title} • ${_cartService.selectedDiscountCode!.code}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textMain,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _cartService.selectedDiscountCode!.description,
                                            style: const TextStyle(
                                              color: AppColors.textSub,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '-${_formatVND(_cartService.discount)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        GestureDetector(
                                          onTap: () => _cartService.setDiscountCode(null),
                                          child: const Text(
                                            'Xóa',
                                            style: TextStyle(
                                              color: Colors.red,
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ====== Tổng kết đơn ======
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _infoRowPlain('Tạm tính', _formatVND(_cartService.subtotal)),
                            const SizedBox(height: 6),
                            _infoRowPlain('Giảm giá', '-${_formatVND(_cartService.discount)}'),
                            const Divider(height: 24),
                            _infoRowPlain('Thành tiền', _formatVND(_cartService.grandTotal)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ====== Nút thanh toán ======
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: _buildPaymentButton(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Hình ảnh
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 60,
                height: 60,
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Thông tin
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: const TextStyle(
                    color: AppColors.textSub,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatVND(item.price),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    Row(
                      children: [
                        _buildQuantityButton(
                          icon: Icons.remove,
                          onTap: () => _cartService.updateItemQuantity(
                            item.id,
                            item.type,
                            item.quantity - 1,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            '${item.quantity}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        _buildQuantityButton(
                          icon: Icons.add,
                          onTap: () => _cartService.updateItemQuantity(
                            item.id,
                            item.type,
                            item.quantity + 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Nút xóa
          IconButton(
            onPressed: () => _cartService.removeItem(item.id, item.type),
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 16,
          color: AppColors.textMain,
        ),
      ),
    );
  }

  Widget _infoRowPlain(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textMain, fontSize: 16),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textMain,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentButton(BuildContext context) {
    return BlocConsumer<PaymentBloc, PaymentState>(
      listener: (context, state) async {
        if (state is PaymentSuccess) {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => WebViewPaymentScreen(paymentUrl: state.paymentUrl),
            ),
          );
          if (result == true) {
            // Tìm ticket item để lấy thông tin match
            final ticketItems = _cartService.getItemsByType(CartItemType.ticket);
            if (ticketItems.isNotEmpty && widget.detailsMatch != null) {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) =>
                          CartSuccessfulScreen(matchModel: widget.detailsMatch!),
                ),
              );
              
              final ticketItem = ticketItems.first;
              context.read<PaymentBloc>().add(
                CompleteBookingAndRefreshTicketsEvent(
                  userId: widget.user.uid!,
                  matchId: ticketItem.metadata['matchId'],
                  standId: ticketItem.metadata['standId'],
                  quantity: ticketItem.quantity,
                  token: widget.user.token!,
                ),
              );
              
              // Xóa cart sau khi thanh toán thành công
              _cartService.clearCart();
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Thanh toán thất bại!")),
            );
          }
        } else if (state is PaymentFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Payment failed: ${state.message}")),
          );
        }
      },
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed:
                state is PaymentLoading
                    ? null
                    : () {
                      context.read<PaymentBloc>().add(
                        CreatePaymentEvent(
                          orderId: '${DateTime.now().millisecondsSinceEpoch}',
                          orderInfo: 'ThanhToanVe',
                          amount: _cartService.grandTotal.toStringAsFixed(0),
                          returnUrl:
                              'https://intership.hqsolutions.vn/api/Payment/onepay-return',
                        ),
                      );
                    },
            child:
                state is PaymentLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                      "Payment",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
          ),
        );
      },
    );
  }
}
