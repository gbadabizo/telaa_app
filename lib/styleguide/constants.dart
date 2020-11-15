import 'package:flutter/material.dart';

final primaryColor= Color(0xFF10ac84);
final secondColor = Color(0xFF872954);
final kHintTextStyle = TextStyle(
  color: Color(0xFF10ac84),
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontSize: 20,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),

    ),
  ],

);
final kBoxDecorationStyleSecond = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10.0),
  /*boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),

    ),
  ],*/

);