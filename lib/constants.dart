import 'package:flutter/material.dart';

enum ColorSelection {
  // 1
  deepPurple('Deep Purple', Colors.deepPurple),
  purple('Purple', Colors.purple),
  indigo('Indigo', Colors.indigo),
  blue('Blue', Colors.blue),
  teal('Teal', Colors.teal),
  green('Green', Colors.green),
  yellow('Yellow', Colors.yellow),
  orange('Orange', Colors.orange),
  deepOrange('Deep Orange', Colors.deepOrange),
  pink('Pink', Colors.pink);

  // 2
  const ColorSelection(
    this.label,
    this.color,
  );

  final String label;
  final Color color;
}

class Pallete {

  static const cardColor = Color.fromRGBO(30, 30, 30, 1);
  static const greenColor = Colors.green;
  static const subtitleText = Color(0xffa7a7a7);
  static const inactiveBottomBarItemColor = Color(0xffababab);

  static const Color backgroundColor = Color.fromRGBO(18, 18, 18, 1);
  static const Color gradient1 = Color.fromRGBO(187, 63, 221, 1);
  static const Color gradient2 = Color.fromRGBO(251, 109, 169, 1);
  static const Color gradient3 = Color.fromRGBO(255, 159, 124, 1);
  static const Color borderColor = Color.fromRGBO(52, 51, 67, 1);
  static const Color whiteColor = Colors.white;
  static const Color greyColor = Colors.grey;
  static const Color errorColor = Colors.redAccent;
  static const Color transparentColor = Colors.transparent;

  static const Color inactiveSeekColor = Colors.white38;
}