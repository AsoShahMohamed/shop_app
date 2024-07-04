import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/cart.dart' as cModel;

class CartItem extends StatelessWidget {
  // final int quantity;
  // final double price;
  // final String productId;
  final Products productsList;
  final cModel.CartItem item;

  final ThemeData appTheme;
  const CartItem({
    super.key,
    // required this.quantity,
    // required this.price,
    // required this.productId,
    required this.item,
    required this.productsList,
    required this.appTheme
  });

  @override
  Widget build(BuildContext context) {
    // final ThemeData appTheme = Theme.of(context);

    // final cartItem = cart.items.values.firstWhere((element) {
    //   return element.productId == productId;
    // });

    final product = productsList.items.firstWhere((product) {
      return product.id == item.productId;
    });

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: appTheme.colorScheme.primary,
            foregroundColor: appTheme.colorScheme.onPrimary,
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: FittedBox(
                child: Text('\$ ${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontFamily: 'lato-Bold', fontWeight: FontWeight.w700)),
              ),
            ),
          ),
          title: Text(product.title),
          subtitle: Text(
              'total is: ${(item.price * item.quantity).toStringAsFixed(2)}',
              style: const TextStyle(fontFamily: 'lato-Regular')),
          trailing: CircleAvatar(
            backgroundColor: appTheme.colorScheme.secondary,
            foregroundColor: appTheme.colorScheme.onSecondary,
            child: Text(
              '${item.quantity} x',
              style: const TextStyle(fontFamily: 'lato-Regular'),
            ),
          ),
        ),
      ),
    );
  }
}
