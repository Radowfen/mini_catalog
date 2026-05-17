import 'package:flutter/foundation.dart';
import 'product.dart';

/// Favoriler için basit state.
///
/// CartModel ile aynı pattern: ChangeNotifier + tek root instance.
class FavoritesModel extends ChangeNotifier {
  final Set<int> _ids = <int>{};
  final List<Product> _items = <Product>[];

  List<Product> get items => List.unmodifiable(_items);
  int get count => _items.length;
  bool get isEmpty => _items.isEmpty;

  bool contains(Product product) => _ids.contains(product.id);

  void toggle(Product product) {
    if (_ids.contains(product.id)) {
      _ids.remove(product.id);
      _items.removeWhere((p) => p.id == product.id);
    } else {
      _ids.add(product.id);
      _items.add(product);
    }
    notifyListeners();
  }

  void remove(Product product) {
    if (_ids.remove(product.id)) {
      _items.removeWhere((p) => p.id == product.id);
      notifyListeners();
    }
  }

  void clear() {
    _ids.clear();
    _items.clear();
    notifyListeners();
  }
}
