import 'dart:convert';

import 'package:flutter/material.dart';

class DetailPhoto extends StatelessWidget {
  String image;

  DetailPhoto(this.image);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Hero(
              tag: 'imageHero',
              child: Image.memory(
                Base64Decoder().convert(image),
              )),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
