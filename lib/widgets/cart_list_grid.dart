import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart' as cModel;
import '../providers/products.dart';
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartListView extends StatefulWidget {
  @override
  State<CartListView> createState() => _CartListViewState();
}

class _CartListViewState extends State<CartListView> {
  @override
  Widget build(BuildContext context) {
    final Products products = Provider.of<Products>(context, listen: false);

    final cModel.Cart cart = Provider.of<cModel.Cart>(context, listen: false);

    final ThemeData appTheme = Theme.of(context);

    return Column(
      children: [
        Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 20,
                        color: appTheme.colorScheme.onPrimary,
                      ),
                    ),
                    const Spacer(),
                    Chip(
                      label: Consumer<cModel.Cart>(builder: (_, cart, __) {
                        return Text(
                            '\$ ${cart.totalAmount.toStringAsFixed(2)}');
                      }),
                      backgroundColor: appTheme.colorScheme.primary,
                      labelStyle: appTheme.textTheme.titleSmall,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    OrderNowButton(
                      cart: cart,
                      products: products,
                      appTheme: appTheme,
                    )
                  ],
                ))),
        const SizedBox(
          height: 2,
        ),
        Divider(
          color: appTheme.colorScheme.secondary,
          thickness: 1,
        ),
        const SizedBox(
          height: 2,
        ),
        Expanded(
          child: Consumer<cModel.Cart>(builder: (_, cart, __) {
            final cartList = cart.items.values.toList();

            return ListView(
                children: cartList.map((item) {
              return Dismissible(
                confirmDismiss: (DismissDirection direction) {
                  // return showDialog(context: context, builder:(_)=>AlertDialog(actions: [ElevatedButton(onPressed: (){}, child: Text('dsads') )],));

                  if (direction == DismissDirection.endToStart) {
                    return showDialog(
                      context: context,
                      builder: (BuildContext builderContext) {
                        return AlertDialog(
                            title: const Text('remove Item from Cart'),
                            content: const Text('choose yes or no'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Yes'),
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                              ),
                              TextButton(
                                child: Text('No'),
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                              )
                            ]);
                      },
                    );
                  }

                  return Future.value(false);
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  color: appTheme.colorScheme.error,
                  child:
                      const Icon(Icons.delete, size: 40, color: Colors.white),
                ),
                onDismissed: (DismissDirection direction) {
                  cart.removeItem(item.productId);
                },
                key: ValueKey(item.productId),
                child: CartItem(

                    // quantity: cartList[counter].quantity,
                    // price: cartList[counter].price,
                    appTheme: appTheme,
                    item: item,
                    productsList: products),
              );
            }).toList());
          }),
        ),
      ],
    );
  }
}

class OrderNowButton extends StatefulWidget {
  final cModel.Cart cart;
  final Products products;
  final ThemeData appTheme;
  const OrderNowButton(
      {required this.cart, required this.products, required this.appTheme});

  @override
  State<OrderNowButton> createState() {
    return _OrderNowButtonState();
  }
}

class _OrderNowButtonState extends State<OrderNowButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ?  const CircularProgressIndicator():ElevatedButton(
            onPressed: (widget.cart.totalAmount <= 0)? (){} : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                  widget.cart.items.values.toList(),
                  widget.cart.totalAmount,
                  widget.products);

              setState(() {
                _isLoading = false;
              });
              widget.cart.clearCart();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: widget.appTheme.colorScheme.secondary,
                elevation: 0),
            child: const Text('Complete Order'),
          );
        
  }
}
////edit product price to show 2 provider dependency effects


// Expanded(
//           child: ListView.builder(
//             itemBuilder: (cntx, i) {
//               return ElevatedButton(
//                   onPressed: () {
//                     products.editProductPrice(products.items[i].id,products.items[i].price);
//                   },
//                   child: Text(
//                       'increase value of ${products.items[i].title} by 10usd'));
//             },
//             itemCount: products.items.length,
//           ),
//         )