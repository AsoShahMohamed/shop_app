import 'package:flutter/material.dart';

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({required WidgetBuilder builder, RouteSettings? settings})
      : super(builder: builder, settings: settings);
  @override
  Widget buildTransitions(_, controllerPush, controllerPop, widget) {
     print('customroute');
    if (settings.name == '/') {
      return widget;
    }

//default for every customroute (this class ) transition cuz no route name is set

    if (settings.name == '/orders') {
     
      return FadeTransition(
        opacity: controllerPush,
        child: widget,
      );
    }

    if (settings.name == '/edit-products') {
      return SlideTransition(
        position: Tween<Offset>(begin: Offset(1, 0), end: Offset(0.0, 0.0))
            .animate(controllerPush),
        child: widget,
      );
    }
    return SlideTransition(
      position: Tween<Offset>(begin: Offset(-1, 0), end: Offset(0.0, 0.0))
          .animate(controllerPush),
      child: widget,
    );
  }
}
