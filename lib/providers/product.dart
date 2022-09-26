import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isfavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isfavorite = false,
  });

  Future<void> toggleFavorite(String token, String userId) async {
    isfavorite = !isfavorite;
    notifyListeners();
    var oldStatus = isfavorite;
    final url =
        'https://flutter-db-e588c-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    try {
      await http
          .put(Uri.parse(url),
              body: json.encode(
                isfavorite,
              ))
          .then((res) {
        if (res.statusCode >= 400) {
          isfavorite = oldStatus;
          notifyListeners();
        }
      });
    } catch (err) {
      isfavorite = oldStatus;
      notifyListeners();
    }
  }
}
