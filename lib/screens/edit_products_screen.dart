import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/main_drawer.dart';
import '../providers/products.dart';
import '../widgets/editable_product.dart';
import '../screens/editable_products_screen.dart';

class EditableProducts extends StatelessWidget {
  static const routeName = '/edit_products';

  Future<void> _loadNewProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<Products>(context);
    final appTheme = Theme.of(context);
    return Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          title: const Text('edit the products!'),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.add,
                  color: appTheme.colorScheme.secondary,
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditableProductsScreen.routeName);
                })
          ],
        ),
        body: FutureBuilder(
          future: _loadNewProducts(context),
          builder: (cntx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return RefreshIndicator(
                displacement: 100,
                onRefresh: () {
                  return _loadNewProducts(context);
                },
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Consumer<Products>(builder: (_, products, ch) {
                      return ListView.builder(
                          itemCount: products.items.length,
                          itemBuilder: (_, i) {
                            return EditableProduct(
                                removeP: products.deleteProduct,
                                id: products.items[i].id,
                                title: products.items[i].title,
                                price: products.items[i].price,
                                imageUrl: products.items[i].imageUrl);
                          });
                    })),
              );
            }
          },
        ));
  }
}
