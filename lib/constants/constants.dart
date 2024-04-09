
import 'package:flutter/material.dart';

Color kPrimaryGreen = const Color(0xFF27742D);
Color kPrimaryGreenAccent = const Color(0xFFF5FAF6);
Color kPrimaryColor = const Color(0xFF6d49a7);
Color kPrimaryAccent = const Color(0xfff7f6fb);

InputDecoration kFormFieldDecoration = const InputDecoration(
  border: OutlineInputBorder(),
  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
  labelStyle: TextStyle(color: Color(0xFF808080), fontSize: 12),
);

List<BoxShadow> kBoxShadowList = [
  BoxShadow(
    color: Colors.grey.withOpacity(0.2),
    spreadRadius: 1,
    blurRadius: 10,
    offset: const Offset(2, 2),
  ),
];