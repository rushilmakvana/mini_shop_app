import 'package:flutter/material.dart';
// import '../providers/product.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.price,
    required this.quantity,
    required this.title,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemcount {
    return _items.length;
  }

  double get Total {
    double total = 0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addItem(String pId, double nprice, String ntitle) {
    if (_items.containsKey(pId)) {
      _items.update(
        pId,
        (value) => CartItem(
            id: value.id,
            price: value.price,
            quantity: value.quantity + 1,
            title: value.title),
      );
    } else {
      _items.putIfAbsent(
        pId,
        () => CartItem(
          id: DateTime.now().toString(),
          price: nprice,
          quantity: 1,
          title: ntitle,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String pid) {
    _items.remove(pid);
    notifyListeners();
  }

  void removeSingle(String pId) {
    if (!_items.containsKey(pId)) {
      return;
    }
    if (_items[pId]!.quantity > 1) {
      _items.update(
          pId,
          (value) => CartItem(
                id: value.id,
                price: value.price,
                quantity: value.quantity - 1,
                title: value.title,
              ));
    } else {
      _items.remove(pId);
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
