import 'package:flutter/material.dart';
import 'package:telaa_app/styleguide/text_style.dart';

class ProfileInfoBigCard extends StatelessWidget {
  final  String firstext ;
  final String secondtext;
  final Widget icon ;

  ProfileInfoBigCard( this.firstext,  this.secondtext,  this.icon);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, top:8, bottom: 4, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
                child: icon)
            ,
            Text(firstext, style: subTitleStyle,),
            Text(secondtext, style: subTitleStyle,)
          ],
        ),
      ),
    );
  }
}
