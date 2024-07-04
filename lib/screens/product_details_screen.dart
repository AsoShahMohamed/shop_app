import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/product.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/product-details';
  @override
  Widget build(BuildContext context) {
    const SizedBox marginBox = SizedBox(
      height: 25,
    );
    final route = ModalRoute.of(context);

    final pid;
    if (route != null) {
      pid = route.settings.arguments as String;
    } else {
      return const Center(
          child: Text('the item is not found!!',
              style: TextStyle(color: Colors.red, fontSize: 18)));
    }

    final Product product = Provider.of<Products>(context).getProductById(pid);

    return Scaffold(
      // appBar: AppBar(title: Text(product.title)),

      body: CustomScrollView(slivers: [
        SliverAppBar(pinned: true,
            // title: Text(product.id),
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                  tag: product.id,
                  child: Image.network(product.imageUrl, fit: BoxFit.contain)),
              stretchModes: <StretchMode>[
                StretchMode.zoomBackground,
                StretchMode.fadeTitle,
                StretchMode.blurBackground
              ],
              title: Text(product.id),
              collapseMode: CollapseMode.parallax,
            )),

        // Container(
        //     width: double.infinity,
        //     height: 300,
        //     child: Hero(
        //         tag: product.id,
        //         child: Image.network(product.imageUrl, fit: BoxFit.contain))),
        // marginBox,
        // Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        //   Text('\$${product.price}',
        //       style: const TextStyle(
        //           color: Colors.grey, fontFamily: 'Lato-Regular'))
        // ]),
        // marginBox,
        // Container(
        //   width: double.infinity,
        //   child: Text(product.description,
        //       textAlign: TextAlign.center,
        //       softWrap: true,
        //       style: const TextStyle(fontFamily: 'Lato-Regular', fontSize: 20)),
        // )

        SliverList(
            delegate: SliverChildListDelegate(<Widget>[
          marginBox,
          Container(
            width: double.infinity,
            child: Text(product.description,
                textAlign: TextAlign.center,
                softWrap: true,
                style:
                    const TextStyle(fontFamily: 'Lato-Regular', fontSize: 20)),
          ),
          marginBox,
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('\$${product.price}',
                style: const TextStyle(
                    color: Colors.grey, fontFamily: 'Lato-Regular'))
          ]),
        ]))
      ]),
    );
  }
}
