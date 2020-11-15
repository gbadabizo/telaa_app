import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:telaa_app/screen/common/radial_progress.dart';
import 'package:telaa_app/screen/common/rounded_image.dart';
import 'package:telaa_app/styleguide/text_style.dart';

class MyInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RadialProgress(
            child: RoundedImage(
              imagePath: "assets/images/img-p2.png",
              size: Size.fromWidth(100.0),
            ),
          ),

          SizedBox(height: 2,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
             // Text("Couture  YaYra", style: whiteNameTextStyle,),
             // Text(" Agoè Assiyéyé" ,style:  whiteSubHeadingTextStyle,)
            ],
          ),


        ],
      ),
    );
  }
}
