import 'package:flutter/material.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/edit_products_screen.dart';
import 'package:shop_app/widgets/user_product_item.dart';
import '../providers/products.dart';
import '../widgets/drawer.dart';
import 'package:provider/provider.dart';

class UserProductScreen extends StatelessWidget {
  Future<void> _refreshproducts(
      BuildContext context, String token, String uid) async {
    await Provider.of<Products>(context, listen: false)
        .getData(token, uid, true);
  }

  static final routeName = 'user-products';
  Widget build(BuildContext context) {
    print('building');
    final authData = Provider.of<Auth>(context, listen: false);
    // final products = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
              // Navigator.push(
              //   context,
              //   PageRouteBuilder(
              //     pageBuilder: ((context, animation, secondaryAnimation) =>
              //         SlideTransition(
              //           position:
              //               Tween<Offset>(begin: Offset(1, 0), end: Offset.zero)
              //                   .animate(animation),
              //           child: EditProductScreen(),
              //         )),
              //   ),
              // );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future:
            _refreshproducts(context, authData.Token as String, authData.uId),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshproducts(
                        context, authData.Token as String, authData.uId),
                    child: Consumer<Products>(
                      builder: (ctx, products, _) => Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView.builder(
                          itemBuilder: (cxt, i) => Column(
                            children: [
                              UserProductItem(
                                products.items[i].imageUrl,
                                products.items[i].title,
                                products.items[i].id,
                              ),
                              const Divider(
                                thickness: 2,
                                indent: 5,
                                endIndent: 5,
                              ),
                            ],
                          ),
                          itemCount: products.items.length,
                        ),
                      ),
                    ),
                  ),
      ),
      drawer: AppDrawer(),
    );
  }
}
