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
import 'package:football_ticket/screens/payment/webview_payment_screen.dart';
import 'package:football_ticket/screens/cart/cart_successful_screen.dart';

class CartScreen extends StatefulWidget {
  final MatchDetailsModel detailsMatch;
  final UserModel user;
  final StandModel stand;
  final double totlePrice; // giữ nguyên tên biến hiện có
  final int quantity;

  const CartScreen({
    super.key,
    required this.detailsMatch,
    required this.user,
    required this.stand,
    required this.totlePrice,
    required this.quantity,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
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

  DiscountCodeModel? _selectedCode;

  double get _subTotal => widget.totlePrice;

  double get _discount {
    if (_selectedCode == null) return 0;
    return _selectedCode!.calcDiscount(_subTotal);
  }

  double get _grandTotal {
    final total = _subTotal - _discount;
    return total < 0 ? 0 : total;
  }

  String _formatVND(num value) {
    // đơn giản: không dùng intl để tránh import thêm
    final s = value.toStringAsFixed(0);
    // thêm dấu . phân cách nghìn
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idx = s.length - i;
      buf.write(s[i]);
      final remain = s.length - i - 1;
      if (remain > 0 && remain % 3 == 0) buf.write('.');
    }
    return '${buf.toString()}đ';
  }

  Future<void> _openDiscountPicker() async {
    DiscountCodeModel? picked = _selectedCode;

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
            final subTotal = _subTotal; // tránh capture nhầm

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
                              // ✅ cập nhật state màn chính sau khi xác nhận
                              setState(() => _selectedCode = picked);
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ====== Card thông tin trận ======
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Image.network(
                                  widget.detailsMatch.match.homeTeam.logo,
                                  width: 50,
                                  height: 40,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  widget.detailsMatch.match.homeTeam.teamName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              "VS",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Column(
                              children: [
                                Image.network(
                                  widget.detailsMatch.match.awayTeam.logo,
                                  width: 50,
                                  height: 40,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  widget.detailsMatch.match.awayTeam.teamName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _infoRow(
                          Icons.access_time,
                          widget.detailsMatch.match.matchTime,
                        ),
                        const SizedBox(height: 6),
                        _infoRow(Icons.location_on_outlined, "Go Dau"),
                        const SizedBox(height: 6),
                        _plainText("Stand: ${widget.stand.standName}"),
                        const SizedBox(height: 4),
                        _plainText(
                          "Remaining Tickets: ${widget.stand.availabelTickets}",
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            "assets/images/stadium.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ====== Tóm tắt giá & Quantity ======
                  _infoRowPlain("Quantity:", widget.quantity.toString()),
                  const SizedBox(height: 8),
                  _infoRowPlain("Subtotal:", _formatVND(_subTotal)),

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
                        if (_selectedCode != null) ...[
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
                                        '${_selectedCode!.title} • ${_selectedCode!.code}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textMain,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _selectedCode!.description,
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
                                      '-${_formatVND(_discount)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    GestureDetector(
                                      onTap:
                                          () => setState(
                                            () => _selectedCode = null,
                                          ),
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
                        _infoRowPlain('Tạm tính', _formatVND(_subTotal)),
                        const SizedBox(height: 6),
                        _infoRowPlain('Giảm giá', '-${_formatVND(_discount)}'),
                        const Divider(height: 24),
                        _infoRowPlain('Thành tiền', _formatVND(_grandTotal)),
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
      ),
    );
  }

  Widget _infoRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSub),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: AppColors.textSub, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _plainText(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(color: AppColors.textSub, fontSize: 14),
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
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) =>
                        CartSuccessfulScreen(matchModel: widget.detailsMatch),
              ),
            );
            context.read<PaymentBloc>().add(
              CompleteBookingAndRefreshTicketsEvent(
                userId: widget.user.uid!,
                matchId: widget.detailsMatch.idMatch,
                standId: widget.stand.standId,
                quantity: widget.quantity,
                token: widget.user.token!,
              ),
            );
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
                      // ====== Gửi tổng sau giảm qua payment ======
                      context.read<PaymentBloc>().add(
                        CreatePaymentEvent(
                          orderId: '${DateTime.now().millisecondsSinceEpoch}',
                          orderInfo: 'ThanhToanVe',
                          amount: _grandTotal.toStringAsFixed(0),
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
