import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

import '../widgets/Product_item.dart';

class ProductsGridView extends StatelessWidget {
  @override
  final bool _showFavouritesOnly;

  const ProductsGridView(this._showFavouritesOnly);

  Widget build(BuildContext context) {
    final existingProducts = !_showFavouritesOnly
        ? Provider.of<Products>(context).items
        : Provider.of<Products>(context).favouriteItems;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          childAspectRatio: 3 / 2),
      itemBuilder: (cntx, i) {
        return ChangeNotifierProvider.value(
            value: existingProducts[i], child: ProductItem());
      },
      itemCount: existingProducts.length,
    );
  }
}
