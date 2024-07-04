import 'package:flutter/material.dart';

class CustomPageTransitionsBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
   
      PageRoute<T> route, _, pushAnimation, popAnimation, child) {

    if (route.settings.name == '/') {
      return child;
    }
  
    return FadeTransition(
      opacity: pushAnimation,
      child: child,
    );
  }
}
