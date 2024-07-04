import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop_app/screens/splash_screen.dart';
import './screens/product_details_screen.dart';
import './screens/product_overview.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/edit_products_screen.dart';
import './screens/editable_products_screen.dart';
import './screens/auth_screen.dart';
import './providers/authentication.dart';
import './helpers/custom_page_transitions_builder.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData mainTheme = ThemeData(fontFamily: 'Anton');
    mainTheme = mainTheme.copyWith(
      textTheme: mainTheme.textTheme.copyWith(
          titleSmall: const TextStyle(
              fontSize: 13,
              overflow: TextOverflow.fade,
              fontFamily: 'Lato-Bold',
              fontWeight: FontWeight.w700)),
      colorScheme: mainTheme.colorScheme.copyWith(
          primary: Color(int.parse('EAD94C', radix: 16) + 0xFF000000),
          secondary: Color(int.parse('3B3561', radix: 16) + 0xFF000000),
          surface: Color(int.parse('51A3A3', radix: 16) + 0xFF000000),
          tertiary: Color(int.parse('DD7373', radix: 16) + 0xFF000000),
          onSurface: Colors.white,
          onSecondary: Colors.white,
          onPrimary: Colors.black87),
   
   pageTransitionsTheme: PageTransitionsTheme(builders: 
    {TargetPlatform.android : CustomPageTransitionsBuilder() }
   ) );
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<Authentication>(
            create: (_) {
              return Authentication();
            },
          ),

          ChangeNotifierProxyProvider<Authentication, Products>(
            create: (_) {
              return Products('', '');
            },
            update: (_, auth, prevProducts) {
              //no need to pass the items as it will be requested from the start all over again upon logging in
              return Products(auth.token == null ? '' : auth.token!,
                  auth.userId == null ? '' : auth.userId!);
            },
          ),

          ChangeNotifierProxyProvider<Authentication, Orders>(create: (_) {
            return Orders('', '');
          }, update: (_, auth, prevOrders) {
            return Orders(auth.token == null ? '' : auth.token!,
                auth.token == null ? '' : auth.userId!);
          }),

          // ChangeNotifierProvider<Products>(create: (cntx) {
          //   return Products();
          // }),
          ChangeNotifierProxyProvider<Products, Cart>(create: (cntx) {
            return Cart();
          }, update: (_, products, previousCart) {
            if (previousCart != null) {
              return previousCart.updateItems(products.items);
            }

            return Cart();
          })
          // ChangeNotifierProvider(
          //   create: (cntx) {
          //     return Cart();
          //   },
          // ),
        ],
        child: Consumer<Authentication>(builder: (context, auth, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MyShop',
            theme: mainTheme,
            home: auth.isAuthenticated
                ? ProductOverview()
                : FutureBuilder(
                    future:  auth.tryAutoLogin(),
                    builder: (cntx, snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthenticationScreen();
                    },
                  ),
            routes: {
              // AuthenticationScreen.route: (cntx) {
              //   return AuthenticationScreen();
              // },
              EditableProducts.routeName: (cntx) {
                return EditableProducts();
              },
              ProductDetailsScreen.routeName: (cntx) {
                return ProductDetailsScreen();
              },
              // ProductOverview.routeName: (cntx) {
              //   return ProductOverview();
              // },
              CartScreen.routeName: (cntx) {
                return CartScreen();
              },
              OrdersScreen.routeName: (cntx) {
                return OrdersScreen();
              },
              EditableProductsScreen.routeName: (cntx) {
                return EditableProductsScreen();
              }
            },
          );
        }));
  }
}
