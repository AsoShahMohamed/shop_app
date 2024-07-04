import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/authentication.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Product product = Provider.of<Product>(context, listen: false);
    final Cart cart = Provider.of<Cart>(context, listen: false);
    final ThemeData appTheme = Theme.of(context);
    //could return the token through provider as well..

    final auth = Provider.of<Authentication>(context, listen: false);
    final String token = auth.token!;
    final String userID = auth.userId;
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.elliptical(5, 5)),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor:
              Theme.of(context).colorScheme.surface.withOpacity(0.85),
          leading: Consumer<Product>(builder: (cntx, p, _) {
            return IconButton(
              icon: Icon(
                p.isFavourite ? Icons.favorite : Icons.favorite_outline,
                color: Colors.white,
              ),
              onPressed: () {
                p.toggleFavourite(token, userID);
              },
            );
          }),
          title: Text(
            product.title,
            style: Theme.of(context).textTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            onPressed: () {
              final sMessenger = ScaffoldMessenger.of(context);
              cart.addCartItem(product.id, product.price);

              // sMessenger.hideCurrentSnackBar();

              sMessenger.showSnackBar(SnackBar(
                action: SnackBarAction(
                    label: 'undo',
                    onPressed: () {
                      cart.removeSingleItemFromCart(product.id);
                    },
                    textColor: appTheme.colorScheme.onSurface),
                content: const Text(
                  'Added to your cart',
                  textAlign: TextAlign.center,
                ),
                backgroundColor: appTheme.colorScheme.surface,
                duration: const Duration(seconds: 2),
              ));
            },
          ),
        ),
        child: GestureDetector(
            child: Hero(
              tag: product.id,
              // flightShuttleBuilder: (_,anime,dir,___,__){

              //   return FadeTransition(opacity: anime , child:
              //  dir == HeroFlightDirection.push?Text('dsad'):Text('aaa')
              //  );
              // },
              child: FadeInImage(
                  placeholderFit: BoxFit.cover,
                  fit: BoxFit.cover,
                  placeholder:
                      AssetImage('assets/images/image-placeholder.png'),
                  image: NetworkImage(product.imageUrl)),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushNamed('/product-details', arguments: product.id);
            }),
      ),
    );
  }
}
