import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/widgets/drawer.dart';
import '../widgets/order_item.dart';
import '../providers/orders.dart' show Orders;

class OrdersScreen extends StatefulWidget {
  static const routeName = 'orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future? ordersFuture;

  Future obtainFuture() {
    final authData = Provider.of<Auth>(context, listen: false);
    return Provider.of<Orders>(context, listen: false).fetchOrders(
      authData.Token as String,
      authData.uId,
    );
  }

  // final orderData = [];
  var isloading = true;
  @override
  void initState() {
    // Future.delayed(Duration.zero).then((_) async {
    //   await Provider.of<Orders>(context, listen: false).fetchOrders();
    //   setState(() {
    //     isloading = false;
    //   });
    // });
    ordersFuture = obtainFuture();
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Consumer<Orders>(
            builder: (ctx, value, child) => ListView.builder(
              itemCount: value.orders.length,
              itemBuilder: ((context, index) => OrderItem(
                    value.orders[index],
                  )),
            ),
          );
        },
      ),
      //  isloading
      //     ?
      //     :
      //     // Center(),
      //     ListView.builder(
      //         itemCount: orderData.orders.length,
      //         itemBuilder: ((context, index) => OrderItem(
      //               orderData.orders[index],
      //             )),
      //       ),
      drawer: AppDrawer(),
    );
  }
}
