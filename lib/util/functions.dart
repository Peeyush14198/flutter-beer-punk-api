import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class CustomFunctions{
  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
   void customNavigation(BuildContext context, Widget navigateTo) {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.leftToRight, child: navigateTo));
  }

  void removeAllRoutes(BuildContext context, Widget navigateTo) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => navigateTo),
        (Route<dynamic> route) => false);
  }
}