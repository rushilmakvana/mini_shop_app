import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/drawer.dart';
import '../widgets/product_grid.dart';

enum FilterOptions {
  favorites,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var isfavorite = false;
  var isinit = true;
  var isloading = true;
  @override
  void didChangeDependencies() {
    final authData = Provider.of<Auth>(context, listen: false);
    if (isinit) {
      Provider.of<Products>(context)
          .getData(authData.Token as String, authData.uId)
          .then((_) {
        setState(() {
          isloading = false;
        });
      });
    }
    isinit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // var cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'MyShop',
          // ignore: deprecated_member_use
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == FilterOptions.favorites) {
                setState(() {
                  isfavorite = true;
                });
              } else {
                setState(() {
                  isfavorite = false;
                });
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.favorites,
                child: Text('Your Favorites'),
              ),
              const PopupMenuItem(
                value: FilterOptions.all,
                child: Text('All products'),
              )
            ],
          ),
          // Icon(
          //   Icons.shopping_cart,
          // ),
          Consumer<Cart>(
            builder: ((_, cart, __) => Badge(cart.itemcount.toString())),
          ),
        ],
      ),
      body: isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(isfavorite),
      drawer: AppDrawer(),
    );
  }
}
