import 'dart:async';


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telaa_app/services/telaaService.dart';
import 'package:telaa_app/styleguide/constants.dart';




class ScreenSplash extends StatefulWidget {
  @override
  _ScreenSplashState createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  int isPresent = 0;
  String idAtelier = "";
  final TelaaService telaaService = new TelaaService();
  getSharedPreference() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    isPresent = prefs.getInt("isPresent");
    if(isPresent==null) isPresent=0 ;
    if(isPresent==1)
         idAtelier = prefs.getString("idAtelier");
    print(" idatelier:"+idAtelier);
    print(" ispresent:"+isPresent.toString());
  }


  @override
  void initState() {
    super.initState();
    getSharedPreference();
    Timer(
        Duration(seconds: 4),
        () => {

              if (isPresent==1)
                {
                  Navigator.pushReplacementNamed(context, '/home')
                }
              else
                {
                  Navigator.pushReplacementNamed(context, '/login')
                }
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.white),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 95.0),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2,
                        decoration: new BoxDecoration(
                            //shape: BoxShape.circle,
                            image: new DecorationImage(
                          //fit: BoxFit.fill,
                          image: new AssetImage(
                            "assets/images/logo2.png",
                          ),
                        )),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      "Nous prenons soin des mesures de vos cliens",
                      style: TextStyle(
                          color: secondColor,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
