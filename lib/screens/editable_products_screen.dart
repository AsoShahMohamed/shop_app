import 'package:flutter/material.dart';
import '../widgets/edit_product_form.dart';

class EditableProductsScreen extends StatelessWidget {
  static const routeName = '/edit_or_insert_products';

  @override
  Widget build(BuildContext context) {

     final appBar = AppBar(title: const Text('edit/create product'));

    return Scaffold(
      appBar: appBar,
      body: EditProductForm(),
    );
  }
}
