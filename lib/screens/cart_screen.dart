import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/cart_item.dart';
import 'package:shop_app/widgets/drawer.dart';

class CartScreen extends StatelessWidget {
  static final routeName = 'cartscreen';

  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Cart',
        ),
        centerTitle: true,
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Card(
            elevation: 3,
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Chip(
                    label: Text(
                      '\$${cart.Total}',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  const Spacer(),
                  OrderButton(cart)
                  // ElevatedButton(onPressed: onPressed, child: child)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: ((context, index) => ItemCart(
                    pId: cart.items.keys.toList()[index],
                    id: cart.items.values.toList()[index].id,
                    price: cart.items.values.toList()[index].price,
                    quantity: cart.items.values.toList()[index].quantity,
                    title: cart.items.values.toList()[index].title,
                  )),
              itemCount: cart.items.length,
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton(
    this.cart,
  );

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var isloading = false;
  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context, listen: false);
    return TextButton(
      onPressed: widget.cart.Total <= 0
          ? null
          : () async {
              try {
                setState(() {
                  isloading = true;
                });
                await Provider.of<Orders>(context, listen: false).addOrder(
                  widget.cart.items.values.toList(),
                  widget.cart.Total,
                  authData.Token as String,
                  authData.uId,
                );
                setState(() {
                  isloading = false;
                });
                widget.cart.clearCart();
              } catch (err) {
                print('cannot place order');
              }
            },
      child: isloading
          ? const CircularProgressIndicator(
              // strokeWidth: 2.0,
              // value: 0.5,
              )
          : const Text(
              'Order',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
    );
  }
}
