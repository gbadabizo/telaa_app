import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:telaa_app/screen/commandes.dart';
import 'package:telaa_app/screen/home.dart';
import 'package:telaa_app/screen/profile.dart';
import 'package:telaa_app/styleguide/colors.dart';
import 'package:telaa_app/styleguide/text_style.dart';

class InfosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
      Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/telaa0.jpg"), fit: BoxFit.fill)),
        child: Scaffold(
        //backgroundColor: Colors.white.withOpacity(0.4),
          backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Center(
              child: Text(
            "Informations",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          )),
        ),
        body:
        Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
             /*   Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: new Container(
                        width: double.infinity,
                        height: 300.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                            image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new AssetImage('assets/images/telaa0.jpg'),
                            ))
                    ),
                  ),
                ),
                Divider(height: 2,color: secondaryColor,),*/
            Card(

              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, top:8, bottom: 8, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(child: Text("Télaa est une application mobile destinée aux couturiers",textAlign: TextAlign.center, style: subTitleStyle,maxLines: 2,)),

                    Center(
                      child: RichText(
                        maxLines: 8,
                        textAlign: TextAlign.center,
                        text:

                        TextSpan(
                          text: 'Avec Télaa vous pouvez : \n ',
                          style: subTitleStyle,

                          children: <TextSpan>[
                            TextSpan(text: 'Enregistrer les mesures de vos clients \n ', style: TextStyle(fontWeight: FontWeight.w200, color: tertiaryColor)),
                            TextSpan(text: 'Enregistrer les commandes  de vos clients \n ', style: TextStyle(fontWeight: FontWeight.w200, color: tertiaryColor)),
                            TextSpan(text: 'Récuperer les clients et  leurs mesures  en cas de perte \n ', style: TextStyle(fontWeight: FontWeight.w200, color: tertiaryColor)),
                          ],
                        ),
                      ),
                    ),
                   Divider(height: 2,color: secondaryColor,),
                    Center(
                      child: RichText(
                        maxLines: 8,
                        textAlign: TextAlign.center,
                        text:

                        TextSpan(
                          text: 'Contactez - nous : \n ',
                          style: subTitleStyle,
                          children: <TextSpan>[
                            TextSpan(text: 'E-mail: telaa228@gmail.com \n ', style: TextStyle(fontWeight: FontWeight.w200, color: secondaryColor)),
                            TextSpan(text: 'Tel: +228 98883933 / 91751012 \n ', style: TextStyle(fontWeight: FontWeight.w200, color: secondaryColor)),

                          ],
                        ),
                      ),
                    ),
                   /* Align(
                        alignment: Alignment.center,
                        child: icon)*/



                  ]
                ),
              ),
            )
              ],
            ),
          ),
        ),
          bottomNavigationBar: CurvedNavigationBar(
            color: primaryColor,
            backgroundColor: Colors.white,
            buttonBackgroundColor: Color(0xFF872954),
            height: 50,
            index: 3,
            items: <Widget>[
              Icon(
                FontAwesomeIcons.home,
                size: 20,
                color: Colors.white,
              ),
              Icon(
                FontAwesomeIcons.shoppingCart,
                size: 20,
                color: Colors.white,
              ),

              Icon(
                FontAwesomeIcons.userCircle,
                size: 20,
                color: Colors.white,
              ),
              Icon(
                FontAwesomeIcons.infoCircle,
                size: 20,
                color: Colors.white,
              ),
            ],
            //  animationDuration: Duration(milliseconds: 200),
            //   animationCurve: Curves.bounceInOut,
            onTap: (index) {
              debugPrint("index du menu $index");
              if (index == 0) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => HomePage()));
              }
              if (index == 1) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CommandesPage()));
              }
              if (index == 2) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => ProfilePage()));
              }
              if (index == 3) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => InfosPage()));
              }
            },
          ),
    ),
      );
  }
}
