import 'package:flutter/material.dart';
import 'package:telaa_app/styleguide/colors.dart';

class OpaqueImage extends StatelessWidget {
  final imageUrl;

  OpaqueImage(this.imageUrl);

  @override
  Widget build(BuildContext context) {

    return
      Stack(
          children: <Widget>[
            Image.asset(
              imageUrl,
              width: double.maxFinite,
              height: double.maxFinite,
              fit: BoxFit.fill,
            ),
            Container(
              color: primaryColor.withOpacity(0.85),
            )
          ],

      );
  }
}
