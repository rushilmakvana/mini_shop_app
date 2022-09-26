import 'package:flutter/material.dart';
import 'package:shop_app/screens/cart_screen.dart';

class Badge extends StatelessWidget {
  final String itemCount;
  Badge(this.itemCount);
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(CartScreen.routeName);
          },
          icon: const Icon(Icons.shopping_cart),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).accentColor,
            ),
            constraints: const BoxConstraints(
              minHeight: 16,
              minWidth: 16,
            ),
            child: Text(
              itemCount,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black,
              ),
            ),
          ),
        )
      ],
    );
  }
}
