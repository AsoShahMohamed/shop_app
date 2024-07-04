import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditProductForm extends StatefulWidget {
  final appbarHeight;
  const EditProductForm(this.appbarHeight);

  @override
  State<EditProductForm> createState() => _EditProductFormstate();
}

class _EditProductFormstate extends State<EditProductForm> {
  final priceFocusNode = FocusNode(onKey: (fn, RawKeyEvent key) {
    return KeyEventResult.handled;
  });

  final descFocusNode = FocusNode(onKey: (fn, RawKeyEvent key) {
    return KeyEventResult.handled;
  });
  final imageUrlNode = FocusNode(onKey: (fn, RawKeyEvent key) {
    return KeyEventResult.handled;
  });
  @override
  void initState() {
    // appBar = AppBar(title: const Text('edit/create product'));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    //  appTheme = Theme.of(context);
    // focusScopeNode = FocusScope.of(context);
    // mqd = MediaQuery.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    priceFocusNode.dispose();

    descFocusNode.dispose();

    super.dispose();
  }

  //could hand finals down from the parent to its children

  @override
  Widget build(BuildContext context) {
    //these
    final appTheme = Theme.of(context);
    final focusScopeNode = FocusScope.of(context);
    final mqd = MediaQuery.of(context);
    //up to here

    return SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(10),
            height: mqd.size.height - widget.appbarHeight,
            margin: EdgeInsets.only(bottom: mqd.viewInsets.bottom + 10),
            child: Form(
              child: Column(children: <Widget>[
                TextFormField(
                    onFieldSubmitted: (val) {
                      focusScopeNode.requestFocus(priceFocusNode);
                    },
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      // FilteringTextInputFormatter(RegExp(r'\d+'),allow: true)
                    ],
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(),
                        border: UnderlineInputBorder(),
                        label: Text('product Name'),
                        hintStyle: TextStyle(
                            color: Colors.grey, fontFamily: 'Anton-Regular'),
                        hintText: 'e.g shower douche')),
                const Divider(
                  height: 5,
                ),
                TextFormField(
                    onFieldSubmitted: (val) {
                      focusScopeNode.requestFocus(descFocusNode);
                    },
                    focusNode: priceFocusNode,
                    // keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(("[0-9]")))
                    ],
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(),
                        // border: UnderlineInputBorder(),
                        label: Text('product Price'),
                        hintStyle: TextStyle(
                            color: Colors.grey, fontFamily: 'Anton-Regular'),
                        hintText: 'e.g 100')),
                TextFormField(
                    onFieldSubmitted: (_) {
                      focusScopeNode.requestFocus(imageUrlNode);
                    },
                    keyboardType: TextInputType.multiline,
                    focusNode: descFocusNode,
                    maxLines: 3,
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(),
                        // border: UnderlineInputBorder(),
                        label: Text('Desc'),
                        hintStyle: TextStyle(
                            color: Colors.grey, fontFamily: 'Anton-Regular'),
                        hintText: 'enter the details of the product !!')),
                Expanded(
                  child: TextFormField(
                    textInputAction: TextInputAction.done,
                      focusNode: imageUrlNode,
                      keyboardType: TextInputType.url,
                      decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(),
                          // border: UnderlineInputBorder(),
                          label: Text(' image Url'),
                          hintStyle: TextStyle(
                              color: Colors.grey, fontFamily: 'Anton-Regular'),
                          hintText: 'e.g https://abc.com/image.png')),
                ),
              ]),
            )));
  }
}
