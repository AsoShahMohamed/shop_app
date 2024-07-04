import 'package:flutter/material.dart';

class StackedBadge extends StatelessWidget {
  final Widget child;
  final int value;

  const StackedBadge(this.child, this.value);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
  child,
      Positioned(
          top: 5,
          right: 5,
          child: Container(
            padding:const  EdgeInsets.all(2),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Text(
                  textAlign: TextAlign.center,
                  value.toString(),
                  style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.onSecondary))))
    ]);
  }
}
