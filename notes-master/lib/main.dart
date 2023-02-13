import 'package:flutter/material.dart';
import 'package:notes/first.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: first(),
    theme: ThemeData(fontFamily: 'noto'),
  ));
}
