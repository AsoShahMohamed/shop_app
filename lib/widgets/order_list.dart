import 'package:flutter/material.dart';
import '../providers/orders.dart' as order_model;
import '../providers/products.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../widgets/order_item.dart';

class OrderListView extends StatelessWidget {
  // @override
  // void initState() {

  //   setState(() {
  //     _isLoading = true;
  //   });

  //   // could be avoided because the provider pacakge allows for
  //   // circumventing the future workaround if listen is set to false

  //   Future.delayed(Duration.zero, () async {
  //     Provider.of<order_model.Orders>(context, listen: false)
  //         .fetchAndSetOrders()
  //         .then((value) => setState(() {
  //               _isLoading = false;
  //             }));
  //   });
  //   super.initState();

  // }

//   @override
//   Widget build(BuildContext context) {
//     final order_model.Orders orders =
//         Provider.of<order_model.Orders>(context, listen: false);
//     final List<Product> products =
//         Provider.of<Products>(context, listen: false).items;
//     return _isLoading
//         ? const Center(child: CircularProgressIndicator())
//         : ListView.builder(
//             itemCount: orders.orders.length,
//             itemBuilder: (_, int counter) {
//               return OrderItem(orders.orders[counter], counter + 1, products);
//             });
//   }
// }

//method 2
// no need stateful widget and a control bool variable, just use futureBuilder
// to capture the current state of the future

  // Future? future;

  // void initState() {
  //   future = _getFuture();

  //   super.initState();
  // }

  // Future<void> _getFuture() {
  //   Provider.of<order_model.Orders>(context, listen: false).fetchAndSetOrders();
  // }

//if somehow the build is recalled  ,eg.. if it adheres to addtional inherited widgets and gets notified
//, there would be additional  and unnecessary  http calls from within this widget , to prevent
//change back to statefulwidget and use the same initstate logic to make the call once and set it to a variable which u will later assign repeatedly

  @override
  Widget build(BuildContext context) {
    final List<Product> products =
        Provider.of<Products>(context, listen: false).items;

    return FutureBuilder<void>(
        future: Provider.of<order_model.Orders>(context, listen: false)
            .fetchAndSetOrders(),
        builder: (context, AsyncSnapshot futureSnapShot) {
          if (futureSnapShot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (futureSnapShot.connectionState == ConnectionState.done) {
            if (!futureSnapShot.hasError) {
              return Consumer<order_model.Orders>(builder: (_, orders, child) {
                return ListView.builder(
                    itemCount: orders.orders.length,
                    itemBuilder: (_, int counter) {
                      return OrderItem(
                          orders.orders[counter], counter + 1, products);
                    });
              });
            }

            return Center(child: Text(futureSnapShot.error.toString()));
          }

          return const Center(child: Text('Something Went Wrong..'));
        });
  }
}
