import 'package:flutter/material.dart';

class RoundedImage extends StatelessWidget {
  final String imagePath;
  final Size size ;


  RoundedImage({Key key,@required this.imagePath, this.size = const Size.fromWidth(120.0)}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
        child: Image.asset(
          imagePath,
          width: 120.0,
          height: 120.0,
          fit: BoxFit.cover,
      )
    );
  }
}
