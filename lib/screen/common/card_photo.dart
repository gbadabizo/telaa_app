import 'package:flutter/material.dart';
import 'package:telaa_app/styleguide/text_style.dart';

class CardPhoto extends StatelessWidget {
  final  String firstext ;

  final Widget icon ;

  CardPhoto( this.firstext, this.icon);

  @override
  Widget build(BuildContext context) {
    return  Card(

      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, top:8, bottom: 8, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(child: Text(firstext, style: subTitleStyle,)),
            Align(
                alignment: Alignment.center,
                child: icon)
            ,


          ],
        ),
      ),
    );
  }
}
