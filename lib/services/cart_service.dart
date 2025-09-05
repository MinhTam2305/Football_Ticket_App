import 'package:flutter/foundation.dart';
import 'package:football_ticket/models/cart_item_model.dart';
import 'package:football_ticket/models/discount_code_model.dart';

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<CartItem> _items = [];
  DiscountCodeModel? _selectedDiscountCode;

  // Getters
  List<CartItem> get items => List.unmodifiable(_items);
  DiscountCodeModel? get selectedDiscountCode => _selectedDiscountCode;
  
  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);
  
  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  
  double get discount {
    if (_selectedDiscountCode == null) return 0;
    return _selectedDiscountCode!.calcDiscount(subtotal);
  }
  
  double get grandTotal {
    final total = subtotal - discount;
    return total < 0 ? 0 : total;
  }

  // Methods
  void addItem(CartItem item) {
    final existingIndex = _items.indexWhere((i) => i.id == item.id && i.type == item.type);
    
    if (existingIndex >= 0) {
      // Nếu item đã tồn tại, tăng quantity
      final existingItem = _items[existingIndex];
      _items[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + item.quantity,
      );
    } else {
      // Thêm item mới
      _items.add(item);
    }
    notifyListeners();
  }

  void addMatchAccessories(String matchId, List<CartItem> accessories) {
    for (final accessory in accessories) {
      addItem(accessory);
    }
  }

  void updateMatchTicket(String matchId, String standId, int newQuantity) {
    final ticketId = '${matchId}_${standId}';
    updateItemQuantity(ticketId, CartItemType.ticket, newQuantity);
  }

  void removeItem(String itemId, CartItemType type) {
    _items.removeWhere((item) => item.id == itemId && item.type == type);
    notifyListeners();
  }

  void updateItemQuantity(String itemId, CartItemType type, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(itemId, type);
      return;
    }

    final index = _items.indexWhere((item) => item.id == itemId && item.type == type);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: newQuantity);
      notifyListeners();
    }
  }

  void setDiscountCode(DiscountCodeModel? code) {
    _selectedDiscountCode = code;
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _selectedDiscountCode = null;
    notifyListeners();
  }

  // Helper methods
  CartItem? getItem(String itemId, CartItemType type) {
    try {
      return _items.firstWhere((item) => item.id == itemId && item.type == type);
    } catch (e) {
      return null;
    }
  }

  bool hasItem(String itemId, CartItemType type) {
    return _items.any((item) => item.id == itemId && item.type == type);
  }

  List<CartItem> getItemsByType(CartItemType type) {
    return _items.where((item) => item.type == type).toList();
  }

  List<CartItem> getMatchAccessories(String matchId) {
    return _items.where((item) => 
      item.type == CartItemType.accessory && 
      item.metadata['matchId'] == matchId
    ).toList();
  }

  CartItem? getMatchTicket(String matchId, String standId) {
    final ticketId = '${matchId}_${standId}';
    return getItem(ticketId, CartItemType.ticket);
  }

  // Group items by match for display
  Map<String, List<CartItem>> getItemsGroupedByMatch() {
    final grouped = <String, List<CartItem>>{};
    
    for (final item in _items) {
      final matchId = item.metadata['matchId'] ?? 'general';
      if (!grouped.containsKey(matchId)) {
        grouped[matchId] = [];
      }
      grouped[matchId]!.add(item);
    }
    
    return grouped;
  }
}
