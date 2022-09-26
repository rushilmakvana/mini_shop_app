import 'package:flutter/material.dart';

class CustomRoute extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // TODO: implement buildTransitions

    return FadeTransition(
      opacity: animation,
      child: child,
    );
    // throw UnimplementedError();
  }
}
