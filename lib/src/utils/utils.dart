import 'dart:math';

import 'package:flutter/material.dart';

class Utilities {
  static String capitalize(String text) {
    return '${text[0].toUpperCase()}${text.substring(1)}';
  }

  static String getNamefromEmail(String email) {
    return email.split('@')[0];
  }

  static String getInitials(String firstname, {String? surname}) {
    String firstnameInitial = firstname[0];
    String surnameInitial = surname != null ? surname[0] : '';
    if (surname == null) {
      return firstnameInitial.toUpperCase();
    }
    return '$firstnameInitial$surnameInitial'.toUpperCase();
  }

  static String generateRandomColor() {
    const predefinedColours = [
      '0xFFF44336', //red
      '0xFFE91E63', //pink
      '0xFFFF9800', //orange
      '0xFFFF5722', //deepOrange
      '0xFF4CAF50', //green
      '0xFF009688', //teal
      '0xFF2196F3', //blue
      // 0xFF607D8B, //blueGrey
      '0xFF03A9F4', //lightBlue
      // 0xFF3F51B5, //indigo
      '0xFF9C27B0', //purple
      '0xFF00BCD4', //cyan
      // 0xFF9E9E9E, //grey
      '0xFF673AB7', //deepPurple
      // 0xFF795548, //brown
      '0xFFFFC107', //amber
      // 0xFF8BC34A, //lightGreen
    ];
    Random random = Random();
    return predefinedColours[random.nextInt(predefinedColours.length)];
  }

  static Color codeToColor(String colorCode) {
    return Color(
      int.parse(colorCode),
    ); //.substring(1, 7), radix: 16) + 0xFF000000);
  }
}
