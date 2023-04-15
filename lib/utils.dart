import 'package:flutter/material.dart';

createPageRoute(Widget nextPage,
    {int delayMilliseconds = 500, bool changeBehavior = true}) {
  if (!changeBehavior) {
    return MaterialPageRoute(builder: (context) => nextPage);
  }
  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: delayMilliseconds),
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return nextPage;
    },
    transitionsBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}
