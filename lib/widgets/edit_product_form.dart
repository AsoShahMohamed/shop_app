import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../providers/product.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class EditProductForm extends StatefulWidget {
  // final appbarHeight;
  // const EditProductForm(this.appbarHeight);

  @override
  State<EditProductForm> createState() => _EditProductFormstate();
}

class _EditProductFormstate extends State<EditProductForm> {
  final imageUrlController = TextEditingController();
  final priceFocusNode = FocusNode(onKey: (fn, RawKeyEvent key) {
    return KeyEventResult.handled;
  });

  final descFocusNode = FocusNode(onKey: (fn, RawKeyEvent key) {
    return KeyEventResult.handled;
  });
  final imageUrlNode = FocusNode(onKey: (fn, RawKeyEvent key) {
    return KeyEventResult.handled;
  });
  var id = null;
  var _isLoading = false;
  final _form = GlobalKey<FormState>();
  final _requestSchema = RegExp(
      r'^(http||https||ftp)://([a-zA-Z0-9~!_-]+)(\.[a-zA-Z0-9~~_-]+){1,3}(/[a-zA-Z0-9~!@#%^&*_+={}.|-]+)*(\?[0-9A-Za-z~!@#%^&*()[\]_{};:.,<>`=+-]*)?$',
      multiLine: true,
      dotAll: true);

  var _product =
      Product(id: '', imageUrl: '', title: '', price: 0, description: '');

  bool _isinit = false;
  @override
  void initState() {
    imageUrlNode.addListener(_updateImageUrl);
    // appBar = AppBar(title: const Text('edit/create product'));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isinit == false) {
      id = ModalRoute.of(context)!.settings.arguments;

      if (id != null) {
        _product =
            Provider.of<Products>(context, listen: false).getProductById(id);
        imageUrlController.text = _product.imageUrl;
      }
    }
    _isinit = true;
    //  appTheme = Theme.of(context);
    // focusScopeNode = FocusScope.of(context);
    // mqd = MediaQuery.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    imageUrlNode.removeListener(_updateImageUrl);
    imageUrlController.dispose();
    priceFocusNode.dispose();
    descFocusNode.dispose();
    imageUrlNode.dispose();

    super.dispose();
  }

  //could hand finals down from the parent to its children

  void _updateImageUrl() {
    if (!imageUrlNode.hasFocus) {
      if (!_validateRequestExp()) {
        return;
      } else {
        setState(() {});
      }
    }

    return;
  }

  bool _validateRequestExp() {
    var text = imageUrlController.text;

    // if (text.isEmpty) {
    //   return false;
    // }

    // if ((text.startsWith('http') || text.startsWith('https')) &&
    //     (text.contains('.com') ||
    //         text.contains('.net') ||
    //         text.contains('.org')) &&
    //     (text.endsWith('jpg') ||
    //         text.endsWith('jpeg') ||
    //         text.endsWith('png'))) {
    //   return true;
    // }

    if (_requestSchema.hasMatch(text) &&
        (text.endsWith('.jpg') ||
            text.endsWith('.jpeg') ||
            text.endsWith('.png'))) {
      return true;
    }

    return false;
  }

// or could encapsulate the external saving function inside an async function
// to prevent manipulation during the checking process , to that point should be synchronous??

  Future<void> _saveForm() async {
    if (!_validateForm()!) {
      return;
    }

    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });

    final provider = Provider.of<Products>(context, listen: false);

    if (id != null) {
      //http request is not applied to updating products
      await provider.updateProduct(id, _product);
      Navigator.of(context).pop();
    } else {
      //only such functionality is added to new products

      //future.catcherror.then()  equivalent..
      try {
        await provider.addProduct(_product);
      } catch (error) {
         await showDialog(
            context: context,
            builder: (cntx) {
              return AlertDialog(
                content: const Text('something went wrong..'),
                title: const Text('confirm to dismiss'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(cntx).pop();
                      },
                      child: const Text('okay')),
                ],
              );
            });
      

      } finally {
        Navigator.of(context).pop();
      }
    }
  }

  bool? _validateForm() {
    return _form.currentState?.validate();
  }

  @override
  Widget build(BuildContext context) {
    //these

    final appTheme = Theme.of(context);
    final focusScopeNode = FocusScope.of(context);
    // final mqd = MediaQuery.of(context);
    //up to here
    final errorStyle =
        TextStyle(color: appTheme.colorScheme.error, fontFamily: 'Lato-Bold');

    final errorBorder = UnderlineInputBorder(
        borderSide: BorderSide(color: appTheme.colorScheme.error));
    final focusedErrorBorder = OutlineInputBorder(
        borderSide: BorderSide(color: appTheme.colorScheme.error));

    return _isLoading
        ? Center(
            child: CircularProgressIndicator(
            value: 100,
          ))
        : SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: _form,
                  child: Column(children: <Widget>[
                    TextFormField(
                        initialValue: _product.title,
                        validator: (val) {
                          return val!.isEmpty
                              ? 'title must not be empty'
                              : null;
                        },
                        onSaved: (val) {
                          _product = Product(
                              id: _product.id,
                              description: _product.description,
                              title: val!,
                              imageUrl: _product.imageUrl,
                              price: _product.price,
                              isFavourite: _product.isFavourite);
                        },
                        onFieldSubmitted: (val) {
                          focusScopeNode.requestFocus(priceFocusNode);
                        },
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          // FilteringTextInputFormatter(RegExp(r'\d+'),allow: true)
                        ],
                        decoration: InputDecoration(
                            errorStyle: errorStyle,
                            focusedErrorBorder: focusedErrorBorder,
                            errorBorder: errorBorder,
                            enabledBorder: const UnderlineInputBorder(),
                            border: const UnderlineInputBorder(),
                            label: const Text('product Name'),
                            hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Anton-Regular'),
                            hintText: 'e.g shower douche')),
                    const Divider(
                      height: 10,
                    ),
                    TextFormField(
                        initialValue: _product.price.toString(),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'field mustn\'t be empty';
                          }
                          if (double.tryParse(val) == null) {
                            return 'input is not numeric!';
                          }
                          if (double.parse(val) <= 0) {
                            return 'value mustn\'t be smaller than 0';
                          }

                          return null;
                        },
                        onSaved: (val) {
                          _product = Product(
                              id: _product.id,
                              description: _product.description,
                              title: _product.title,
                              imageUrl: _product.imageUrl,
                              price: double.parse(val!),
                              isFavourite: _product.isFavourite);
                          ;
                        },
                        onFieldSubmitted: (val) {
                          focusScopeNode.requestFocus(descFocusNode);
                        },
                        focusNode: priceFocusNode,
                        // keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp((r"[0-9]")))
                        ],
                        decoration: InputDecoration(
                            errorStyle: errorStyle,
                            errorBorder: errorBorder,
                            focusedErrorBorder: focusedErrorBorder,
                            enabledBorder: const UnderlineInputBorder(),
                            // border: UnderlineInputBorder(),
                            label: const Text('product Price'),
                            hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Anton-Regular'),
                            hintText: 'e.g 100')),
                    const Divider(
                      height: 10,
                    ),
                    TextFormField(
                        initialValue: _product.description,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'field mustn\'t be empty';
                          }

                          if (val.length < 10) {
                            return 'the text shouldn\'t be smaller than 10 characters';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _product = Product(
                              id: _product.id,
                              description: val!,
                              title: _product.title,
                              imageUrl: _product.imageUrl,
                              price: _product.price,
                              isFavourite: _product.isFavourite);
                        },
                        keyboardType: TextInputType.multiline,
                        focusNode: descFocusNode,
                        maxLines: 3,
                        decoration: InputDecoration(
                            errorBorder: errorBorder,
                            errorStyle: errorStyle,
                            focusedErrorBorder: focusedErrorBorder,
                            enabledBorder: const UnderlineInputBorder(),
                            // border: UnderlineInputBorder(),
                            label: const Text('Desc'),
                            hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Anton-Regular'),
                            hintText: 'enter the details of the product !!')),
                    const Divider(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: (!_validateRequestExp())
                              ? const FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    'enter a URL',
                                    style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.w700),
                                  ),
                                )
                              : FittedBox(
                                  fit: BoxFit.contain,
                                  child:
                                      Image.network(imageUrlController.text)),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                              validator: (val) {
                                if (!_validateRequestExp()) {
                                  return 'the request Schema is not valid, or empty';
                                }

                                return null;
                              },
                              onSaved: (val) {
                                _product = Product(
                                    id: _product.id,
                                    description: _product.description,
                                    title: _product.title,
                                    imageUrl: val!,
                                    price: _product.price,
                                    isFavourite: _product.isFavourite);
                              },
                              controller: imageUrlController,
                              textInputAction: TextInputAction.done,
                              focusNode: imageUrlNode,
                              keyboardType: TextInputType.url,
                              decoration: InputDecoration(
                                  errorBorder: errorBorder,
                                  errorStyle: errorStyle,
                                  focusedErrorBorder: focusedErrorBorder,
                                  enabledBorder: const UnderlineInputBorder(),
                                  // border: UnderlineInputBorder(),
                                  label: const Text(' image Url'),
                                  hintStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Anton-Regular'),
                                  hintText: 'e.g https://abc.com/image.png'),
                              onFieldSubmitted: (_) {
                                _saveForm();
                              }),
                        ),
                      ],
                    ),
                  ]),
                )));
  }
}
