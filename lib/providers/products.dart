import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  final String token;
  final String userId;
  Products(this.token, this.userId);

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  Future<void> fetchAndSetProducts([bool setUser = false]) async {
    try {
      var uri = Uri.https(
          'shop-app-60819-default-rtdb.europe-west1.firebasedatabase.app',
          '/products.json',
          !setUser
              ? {'auth': token}
              : {
                  'equalTo': '"$userId"',
                  'orderBy': '"creatorId"',
                  'auth': "$token",
                });

      final List<Product> toBeAssignedList = [];

      final response = await http.get(uri);

      final parsedRecords = json.decode(response.body) as Map<String, dynamic>;

      if (parsedRecords == null) {
        return;
      }

      uri = Uri.https(
          'shop-app-60819-default-rtdb.europe-west1.firebasedatabase.app',
          'usersfavourites/$userId.json',
          {'auth': token});

      final favouritesResponse = await http.get(uri);

      final userFavs = json.decode(favouritesResponse.body);

      parsedRecords.forEach((key, value) {
        toBeAssignedList.add(Product(
          id: key,
          title: value['title'] as String,
          description: value['description'],
          imageUrl: value['imageUrl'],
          price: value['price'] as double,
          isFavourite: userFavs == null ? false : userFavs[key] ?? false,
        ));
      });

      _items = toBeAssignedList;

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  void editProductPrice(String productId, double price) {
    _items.firstWhere((element) {
      return element.id == productId;
    }).price = price + 10;
    notifyListeners();
  }

  List<Product> get favouriteItems {
    return _items.where((product) {
      return product.isFavourite == true;
    }).toList();
  }

  Product getProductById(String pid) {
    return items.firstWhere((product) {
      return product.id == pid;
    });
  }

//could remove the return type (future<void>)

  Future<void> addProduct(Product product) async {
    final path = Uri.https(
        'shop-app-60819-default-rtdb.europe-west1.firebasedatabase.app',
        '/products.json',
        {'auth': token});
    try {
      final response = await http.post(
        path,
        body: json.encode({
          'creatorId': userId,
          'imageUrl': product.imageUrl,
          'title': product.title,
          'description': product.description,
          'price': product.price,
          // 'isfavourite': product.isFavourite,
        }),
      );

      _items.insert(
          0,
          Product(
              description: product.description,
              id: json.decode(response.body)['name'],
              imageUrl: product.imageUrl,
              title: product.title,
              price: product.price));
      // _items.add
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addsyncedProduct(Product product) {
    //adding itesm to the list ..

    final path = Uri.https(
        'shop-app-60819-default-rtdb.europe-west1.firebasedatabase.app',
        '/products.json',
        {'auth': token});

    return http
        .post(path,
            body: json.encode({
              'creatorId': userId,
              'imageUrl': product.imageUrl,
              'title': product.title,
              'description': product.description,
              'price': product.price,
              'isfavourite': product.isFavourite,
            }))
        .then((response) {
      _items.insert(
          0,
          Product(
              description: product.description,
              id: json.decode(response.body)['name'],
              imageUrl: product.imageUrl,
              title: product.title,
              price: product.price));
      // _items.add
      notifyListeners();
    });

    // catchError((error) {

    //   throw error;
    //   //unnesessary catch
    // });
  }

  Future<void> updateProduct(String id, Product product) async {
    final index = _items.indexWhere((p) {
      return p.id == id;
    });
    if (index >= 0) {
      final path = Uri.https(
          'shop-app-60819-default-rtdb.europe-west1.firebasedatabase.app',
          '/products/$id.json',
          {'auth': token});

      await http.patch(path,
          body: json.encode({
            'imageUrl': product.imageUrl,
            'description': product.description,
            'price': product.price,
            'title': product.title
          }));
      _items[index] = product;
    }
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final path = Uri.https(
        'shop-app-60819-default-rtdb.europe-west1.firebasedatabase.app',
        '/products/$id.json',
        {'auth': token});

    final index = _items.indexWhere((element) => element.id == id);

    var existingProduct = _items[index];

    _items.removeWhere((p) {
      return p.id == id;
    });
    // existingProduct = null;
    notifyListeners();
    var response = await http.delete(path);

    if (response.statusCode >= 400) {
      _items.insert(index, existingProduct);
      notifyListeners();

      throw HttpException('status code is equal or Greater than 400');
    }
  }
}
