import 'package:flutter/material.dart';
import '../screens/editable_products_screen.dart';

class EditableProduct extends StatelessWidget {
  final String title;
  final double price;
  final String imageUrl;
  final String id;
  final Function removeP;
  const EditableProduct(
      {required this.removeP,
      required this.id,
      required this.title,
      required this.price,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final scaffoldPointer = ScaffoldMessenger.of(context);
    return Column(
      children: [
        Card(
            child: ListTile(
                leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
                title: Text(title),
                subtitle: Text(price.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.grey)),
                trailing: Container(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: appTheme.colorScheme.secondary,
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                                EditableProductsScreen.routeName,
                                arguments: id);
                          }),
                      IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: appTheme.colorScheme.error,
                          ),
                          onPressed: () async {
                            try {
                              await removeP(id);
                            } catch (error) {
                              scaffoldPointer.showSnackBar(const SnackBar(
                                content: Text('could not remove item'),
                                behavior: SnackBarBehavior.fixed,
                              ));
                              // .closed.then((value) => SnackBarClosedReason.);
                            }
                          }),
                    ],
                  ),
                ))),
        const Divider()
      ],
    );
  }
}
