import 'package:flutter/material.dart';
import 'package:shop_app/providers/exception.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  // String? token;

  List<Product> _items = [];
  // Products(this.token, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favorites {
    return _items.where((p) => p.isfavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> addProduct(Product product, String token, String uId) async {
    final url =
        'https://flutter-db-e588c-default-rtdb.firebaseio.com/products.json?auth=$token';

    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode(
            {
              'title': product.title,
              'description': product.description,
              'price': product.price,
              'imageUrl': product.imageUrl,
              'creatorId': uId,
            },
          ));
      _items.add(
        Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price,
          isfavorite: product.isfavorite,
        ),
      );
      notifyListeners();
    } catch (err) {
      // print(err)
      rethrow;
    }

    // })
    // print(json.decode(response.body)['name']);
  }

  Future<void> updateProduct(String id, Product product, String) async {
    final url =
        'https://flutter-db-e588c-default-rtdb.firebaseio.com/products/$id.json';
    final index = _items.indexWhere((element) => element.id == id);
    await http.patch(
      Uri.parse(url),
      body: json.encode(
        {
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        },
      ),
    );
    // _items.insert(index, product);
    _items[index] = product;
    notifyListeners();
  }

  Future<void> removeProduct(String id, String token) async {
    final url =
        'https://flutter-db-e588c-default-rtdb.firebaseio.com/products/$id.json?auth=$token';
    final prodIdx = _items.indexWhere((product) => product.id == id);
    var TempProduct = _items[prodIdx];
    // http.delete(Uri.parse(url)).then((response) {
    //   if (response.statusCode >= 400) {
    //     // throw Error.safeToString('something went wrong');
    //     throw httpException('cannon delete product');
    //   }
    //   // TempProduct = Product();
    // }).catchError((err) {
    //   _items.insert(prodIdx, TempProduct);
    //   notifyListeners();
    // });
    // // _items.removeWhere((element) => element.id == id);
    _items.removeAt(prodIdx);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      // print('err');
      _items.insert(prodIdx, TempProduct);
      notifyListeners();
      throw httpException('deleting failed');
    }
    print('err');
    // print(response.statusCode);
    // print("id - " + id);
  }

  Future<void> getData(String token, String uId,
      [bool isfiltered = false]) async {
    String filteredStr = isfiltered ? 'orderBy="creatorId"&equalTo="$uId"' : '';

    var url =
        'https://flutter-db-e588c-default-rtdb.firebaseio.com/products.json?auth=$token&$filteredStr';
    try {
      // print('started');
      final response = await http.get(Uri.parse(url));
      // print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData.isEmpty) {
        return;
      }
      url =
          'https://flutter-db-e588c-default-rtdb.firebaseio.com/userFavorites/$uId.json?auth=$token';
      final favoriteResponse = await http.get(Uri.parse(url));
      final favoritesData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, value) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: value['title'],
            description: value['description'],
            imageUrl: value['imageUrl'],
            isfavorite:
                favoritesData == null ? false : favoritesData[prodId] ?? false,
            price: value['price'],
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }
}
