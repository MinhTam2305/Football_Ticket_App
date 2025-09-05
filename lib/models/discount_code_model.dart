class DiscountCodeModel {
  final String id;
  final String code;          // VD: SAVE10
  final String title;         // VD: Giảm 10%
  final String description;   // VD: Áp dụng cho tất cả vé
  final double value;         // số % hoặc số tiền tùy theo isPercent
  final bool isPercent;       // true: %, false: số tiền
  final double? minOrder;     // đơn tối thiểu để áp dụng (null nếu không yêu cầu)
  final double? maxDiscount;  // trần giảm (chỉ áp dụng khi là %)

  const DiscountCodeModel({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.value,
    required this.isPercent,
    this.minOrder,
    this.maxDiscount,
  });

  double calcDiscount(double subtotal) {
    if (minOrder != null && subtotal < (minOrder ?? 0)) return 0;
    if (isPercent) {
      final raw = subtotal * value / 100.0;
      if (maxDiscount != null) {
        return raw > (maxDiscount ?? raw) ? (maxDiscount ?? raw) : raw;
      }
      return raw;
    } else {
      return value > subtotal ? subtotal : value;
    }
  }
}