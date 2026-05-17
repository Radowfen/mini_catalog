import 'package:flutter/foundation.dart';
import 'product.dart';

/// Sepetteki tek bir satır: ürün + adet.
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get lineTotal => product.price * quantity;
}

/// Sepet için basit state yönetimi.
///
/// Gün 5 hedefi: "Sepet butonu ile basit state güncelleme (simülasyon)".
/// ChangeNotifier kullanarak listenleyen widget'ları rebuild eder.
class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => _items.isEmpty;

  double get total => _items.fold(0.0, (sum, item) => sum + item.lineTotal);

  String get formattedTotal => _formatPrice(total);

  /// Sepete ekler. Aynı ürün varsa adedi artırır.
  void add(Product product, {int quantity = 1}) {
    final idx = _items.indexWhere((it) => it.product.id == product.id);
    if (idx >= 0) {
      _items[idx].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  /// Adedi 1 artırır.
  void increment(Product product) => add(product);

  /// Adedi 1 azaltır. 1'in altına düşerse satırı kaldırır.
  void decrement(Product product) {
    final idx = _items.indexWhere((it) => it.product.id == product.id);
    if (idx < 0) return;
    if (_items[idx].quantity <= 1) {
      _items.removeAt(idx);
    } else {
      _items[idx].quantity -= 1;
    }
    notifyListeners();
  }

  void remove(Product product) {
    _items.removeWhere((it) => it.product.id == product.id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  /// Belirli bir ürün için sepetteki adet (0 = yok).
  int quantityOf(Product product) {
    final idx = _items.indexWhere((it) => it.product.id == product.id);
    return idx >= 0 ? _items[idx].quantity : 0;
  }
}

/// $1,299 gibi biçimlendirilmiş fiyat — modeller arası paylaşılan helper.
String _formatPrice(double value) {
  final whole = value.toStringAsFixed(0);
  final buf = StringBuffer(r'$');
  for (int i = 0; i < whole.length; i++) {
    buf.write(whole[i]);
    final remaining = whole.length - i - 1;
    if (remaining > 0 && remaining % 3 == 0) buf.write(',');
  }
  return buf.toString();
}
