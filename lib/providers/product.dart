import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;

  final String title;
  final String description;

  double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavourite = false,
  });

  void _changeFavStatus() {
    this.isFavourite = !isFavourite;
    notifyListeners();
  }

  Future<void> toggleFavourite(String token,String userId) async {
    // final oldStatus = isFavourite;
    this._changeFavStatus();

    final uri = Uri.https(
        'shop-app-60819-default-rtdb.europe-west1.firebasedatabase.app',
        '/usersfavourites/$userId/$id.json',
        {'auth': token});
    try {
      final res = await http.put(uri, body: json.encode(isFavourite));

      if (res.statusCode >= 400) {
        this._changeFavStatus();
      }
    } catch (error) {
    
      this._changeFavStatus();
    }
  }
}
