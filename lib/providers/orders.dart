import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_app/providers/exception.dart';
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.dateTime,
    required this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders(String token, String uId) async {
    final List<OrderItem> loadedProducts = [];
    final url =
        'https://flutter-db-e588c-default-rtdb.firebaseio.com/orders/$uId.json?auth=$token';
    final res = await http.get(Uri.parse(url));
    var extractedData = json.decode(res.body);
    if (extractedData == null) {
      return;
    }
    extractedData = json.decode(res.body) as Map<String, dynamic>;

    extractedData.forEach((key, value) {
      loadedProducts.add(
        OrderItem(
          id: key,
          amount: value['amount'],
          dateTime: DateTime.parse(value['dateTime']),
          products: (value['products'] as List<dynamic>)
              .map(
                (e) => CartItem(
                  id: e['id'],
                  price: e['price'],
                  quantity: e['quantity'],
                  title: e['title'],
                ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedProducts.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(
      List<CartItem> products, double total, String token, String uId) async {
    print('uid = ' + uId);
    final url =
        'https://flutter-db-e588c-default-rtdb.firebaseio.com/orders/$uId.json?auth=$token';
    final timestamp = DateTime.now();
    final res = await http.post(
      Uri.parse(url),
      body: json.encode(
        {
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': products
              .map(
                (e) => {
                  'id': e.id,
                  'title': e.title,
                  'quantity': e.quantity,
                  'price': e.price,
                },
              )
              .toList(),
        },
      ),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(res.body)['name'],
        amount: total,
        dateTime: DateTime.now(),
        products: products,
      ),
    );
    notifyListeners();
    //     .then((res) {
    //   if (res.statusCode >= 400) {
    //     _orders.removeAt(0);
    //     notifyListeners();
    //     throw httpException('cannot place order');
    //   }
    // });
  }
}


// {
//     -NAYCwzl2beEGQjvLwi5:
//      {
//         amount: 99.98,
//         dateTime: 2022-08-28T12:21:04.112, 
//         products: [
//           {
//             id: 2022-08-28 12:20:59.910,
//             price: 59.99,
//             quantity: 1, 
//             title: Trousers
//           }, 
//           {
//             id: 2022-08-28 12:21:01.336, 
//             price: 39.99, 
//             quantity: 1, 
//             title: Red Shirt
//           }]
//       },
//     -NAZ05nxl_m0XS65q4cA: 
//       {
//         amount: 99.98, 
//         dateTime: 2022-08-28T16:04:30.335462, 
//         products: [
//           {
//             id: 2022-08-28 16:04:24.954877, 
//             price: 59.99, 
//             quantity: 1, 
//             title: Trousers
//           },
//           {
//             id: 2022-08-28 16:04:26.383841, 
//             price: 39.99, 
//             quantity: 1, 
//             title: Red Shirt
//           }]
//       }
// }