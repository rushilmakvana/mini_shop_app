import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';

class ItemCart extends StatelessWidget {
  final double price;
  final String title;
  final String pId;
  final String id; 
  final int quantity;
  ItemCart({
    required this.pId,
    required this.id,
    required this.price,
    required this.quantity,
    required this.title,
  });

  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: ((direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Sure ?'),
            content: Text('Are you sure want to remove item from cart ?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text('Yes'),
              )
            ],
          ),
        );
      }),
      key: ValueKey(pId),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        color: Theme.of(context).errorColor,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
      ),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(pId);
      },
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        // child: Padding(
        // padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: ListTile(
          leading: CircleAvatar(
            child: FittedBox(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text('\$$price'),
              ),
            ),
          ),
          title: Text(title),
          subtitle: Text('total : ${price * quantity}'),
          trailing: Text('${quantity}x'),
        ),
        // ),
      ),
    );
  }
}
