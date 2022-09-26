import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_products_screen.dart';

class UserProductItem extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String id;

  UserProductItem(
    this.imgUrl,
    this.title,
    this.id,
  );

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imgUrl),
        ),
        title: Text(title),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.routeName, arguments: id);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () async {
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .removeProduct(
                            id,
                            Provider.of<Auth>(context, listen: false).Token
                                as String);
                  } catch (err) {
                    // print('err');
                    scaffold.showSnackBar(SnackBar(
                      content: Text(
                        'deleting failed',
                        textAlign: TextAlign.center,
                      ),
                    ));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
