import 'package:flutter/material.dart';

ThemeMode themeMode = ThemeMode.light;


OutlineInputBorder border(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(
        color: color,
        width: 3,
      ),
    );
