import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
// import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imgUrl;

  // ProductItem(this.id, this.imgUrl, this.title);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GestureDetector(
            onTap: () => Navigator.of(context)
                .pushNamed(ProductDetail.routename, arguments: product.id),

            // Navigator.push(context, )
            child: GridTile(
              child: Hero(
                tag: product.id,
                child: FadeInImage(
                  fit: BoxFit.cover,
                  placeholder:
                      AssetImage('assets/images/product-placeholder.png'),
                  image: NetworkImage(
                    product.imageUrl,
                  ),
                ),
              ),
              footer: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                child: GridTileBar(
                  backgroundColor: Colors.black87,
                  // Theme.of(context).primaryColor,
                  title: Text(
                    product.title,
                    textAlign: TextAlign.center,
                  ),
                  leading: Consumer<Product>(
                    builder: (context, value, child) => GestureDetector(
                      child: Icon(
                        product.isfavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: const Color.fromARGB(255, 235, 225, 116),
                      ),
                      // ignore: deprecated_member_use
                      onTap: () => product.toggleFavorite(
                          authData.Token as String, authData.uId),
                    ),
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      cart.addItem(product.id, product.price, product.title);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Item added !'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              cart.removeSingle(product.id);
                            },
                          ),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.shopping_cart,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
