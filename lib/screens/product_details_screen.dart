import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:shop_app/models/product.dart';
import '../providers/products.dart';

class ProductDetail extends StatelessWidget {
  static final routename = 'product-details';
  @override
  Widget build(BuildContext context) {
    final prodId = ModalRoute.of(context)?.settings.arguments;
    final product = Provider.of<Products>(context, listen: false)
        .findById(prodId as String);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     product.title,
      //   ),
      //   centerTitle: true,
      //   backgroundColor: Theme.of(context).primaryColor,
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text(
                  product.title,
                  // style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              centerTitle: true,
              background: Hero(
                tag: prodId,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 300,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Text(
                    '\$${product.price}',
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(5),
                  child: Text(
                    product.description,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 1000,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
