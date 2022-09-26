import 'package:flutter/material.dart';
import 'package:shop_app/models/custom_route_transition.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_details_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';
import 'package:shop_app/screens/edit_products_screen.dart';
import './providers/products.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          theme: ThemeData(
            // pageTransitionsTheme: const PageTransitionsTheme(
            //   builders: <TargetPlatform, PageTransitionsBuilder>{
            //     TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            //   },
            // ),
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            }),

            primarySwatch: Colors.deepPurple,
            // ignore: deprecated_member_use
            accentColor: const Color.fromARGB(255, 235, 225, 116),
            // canvasColor: Color.fromARGB(255, 168, 234, 215),
          ),
          routes: {
            // '/': (ctx) => ProductsOverviewScreen(),
            ProductDetail.routename: (ctx) => ProductDetail(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? const Scaffold(
                              body: Center(
                                child: Text('Loading......'),
                              ),
                            )
                          : AuthScreen(),
                ),
        ),
      ),
    );
  }
}
