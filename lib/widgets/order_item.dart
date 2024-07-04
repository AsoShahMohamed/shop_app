import 'dart:math';
import 'package:flutter/material.dart';
import '../providers/orders.dart' as order_model;
import 'package:intl/intl.dart';
import '../providers/product.dart';

class OrderItem extends StatefulWidget {
  final order_model.OrderItem orderItem;
  final int counter;
  final List<Product> products;
  const OrderItem(this.orderItem, this.counter, this.products);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    final ThemeData appTheme = Theme.of(context);

    return Card(
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                  leading: CircleAvatar(
                      backgroundColor: appTheme.colorScheme.primary,
                      foregroundColor: appTheme.colorScheme.onPrimary,
                      child: Text('# ' + widget.counter.toString())),
                  title: Text('\$ ${widget.orderItem.total.toStringAsFixed(2)}',
                      style: TextStyle(fontFamily: 'Lato-Regular')),
                  subtitle: Text(
                      '${DateFormat('dd /MM /yyyy ').add_jms().format(widget.orderItem.datetime)}',
                      style: TextStyle(fontFamily: 'Lato-Regular')),
                  trailing: Container(
                    decoration: BoxDecoration(
                        color: appTheme.colorScheme.secondary,
                        borderRadius:
                            const BorderRadius.all(Radius.elliptical(10, 10))),
                    child: IconButton(
                        splashRadius: 1,
                        onPressed: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                        icon: _isExpanded
                            ? const Icon(Icons.expand_less, color: Colors.white)
                            : const Icon(Icons.expand_more,
                                color: Colors.white)),
                  )),
              if (_isExpanded == true)
                const Divider(
                  thickness: 3,
                ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: _isExpanded == true
                    ? max(widget.orderItem.products.length * 50 + 10, 100)
                    : 0,
                width: double.infinity,
                child: ListView.builder(
                    itemCount: widget.orderItem.products.length,
                    itemBuilder: (_, int counter) {
                      final String pTitle =
                          widget.products.firstWhere((element) {
                        return element.id ==
                            widget.orderItem.products[counter].productId;
                      }).title;
                      return Card(
                        margin: EdgeInsets.all(1),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: appTheme.colorScheme.surface,
                            child: Text(
                                widget.orderItem.products[counter].quantity
                                        .toString() +
                                    ' x',
                                style: TextStyle(
                                    fontFamily: 'Anton-Regular',
                                    color: appTheme.colorScheme.onSurface)),
                          ),
                          title: Text(pTitle),
                          trailing: Text(
                              '\$ ' +
                                  widget.orderItem.products[counter].price
                                      .toString(),
                              style: TextStyle(fontFamily: 'Anton-Regular')),
                       ),
                      );
                    }),
              ),
            ],
          ),
        ));
  }
}
