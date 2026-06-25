import 'package:flutter/material.dart';

extension Navigation on BuildContext {
  void pushNamed(String routeName) {
    Navigator.pushNamed(this, routeName);
  }

  void pushReplacementNamed(String routeName) {
    Navigator.pushReplacementNamed(this, routeName);
  }

  void pop() {
    Navigator.pop(this);
  }
}

extension SizeExtension on BuildContext {
  double width(double ratio) {
    return MediaQuery.sizeOf(this).width * ratio;
  }

  double height(double ratio) {
    return MediaQuery.sizeOf(this).height * ratio;
  }
}
