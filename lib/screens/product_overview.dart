import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/stacked_badge.dart';
import '../widgets/main_drawer.dart';
import '../widgets/products_grid.dart';
import '../providers/cart.dart';
import '../providers/products.dart';

enum ProductFilteringOptions { favorites, all }

class ProductOverview extends StatefulWidget {
  static const routeName = '/';

  @override
  State<ProductOverview> createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  bool _showFavouritesOnly = false;
  // bool _isInit = true;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
//first method
    Future.delayed(Duration.zero, () {
      Provider.of<Products>(context, listen: false)
          .fetchAndSetProducts()
          .then((value) => setState(() {
                _isLoading = false;
              }));
    });
  }

  @override
  void didChangeDependencies() {
    // if (_isInit) {
    //    Provider.of<Products>(context, listen: false).fetchAndSetProducts();
    // }
    // _isInit = false;
    // second method workaround
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('list of Products!'), actions: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PopupMenuButton(
                position: PopupMenuPosition.under,
                icon: const Icon(Icons.more_vert),
                onSelected: (ProductFilteringOptions op) {
                  setState(() {
                    if (op == ProductFilteringOptions.all) {
                      _showFavouritesOnly = false;
                    } else if (op == ProductFilteringOptions.favorites) {
                      _showFavouritesOnly = true;
                    }
                  });
                },
                // initialValue: ProductFilteringOptions.favorites,
                itemBuilder: (cntx) {
                  return const [
                    PopupMenuItem(
                      child: Text('show Favorites!'),
                      value: ProductFilteringOptions.favorites,
                    ),
                    PopupMenuItem(
                        child: Text('show ALL'),
                        value: ProductFilteringOptions.all)
                  ];
                }),
          ],
        ),
        Consumer<Cart>(
          builder: (_, cart, staticChild) {
            if (staticChild != null) {
              return StackedBadge(staticChild, cart.itemsCount);
            }
            return IconButton(
              onPressed: () {},
              icon: const Icon(Icons.error_outline),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  icon: const Icon(Icons.shopping_cart_checkout),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/cart');
                  }),
            ],
          ),
        ),
      ]),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGridView(_showFavouritesOnly),
      drawer: MainDrawer(),
    );
  }
}
