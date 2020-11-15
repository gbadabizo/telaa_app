import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telaa_app/models/Reponse.dart';
import 'package:telaa_app/services/telaaService.dart';
import 'package:telaa_app/styleguide/colors.dart';
import 'package:toast/toast.dart';

class WaitPaiement extends StatefulWidget {
  int idtrans;

  WaitPaiement(this.idtrans);

  @override
  _WaitPaiementState createState() => _WaitPaiementState();
}

class _WaitPaiementState extends State<WaitPaiement> {
   bool isloading = true ;
  TelaaService telaaService = TelaaService();
  // ajout de la date fin au preference
  addDateFinToPref(String datefin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("datefin", datefin);
  }
   void showToast(
       String msg, {
         int duration,
         int gravity,
       }) {
     Toast.show(msg, context,
         duration: duration,
         gravity: gravity,
         backgroundColor: Color(0xFF872954),
         textColor: Colors.white);
   }
  checkpaiement() async {
    Reponse reponse = await telaaService.CheckPay(widget.idtrans);
    if (reponse.code == "800") {
      addDateFinToPref(reponse.datas);
      _showMyDialog(reponse.datas);
    }else{
      isloading=false ;
      setState(() {

      });
    }
  }
   checkpaiementSecond() async {
     Reponse reponse = await telaaService.CheckPay(widget.idtrans);
     if (reponse.code == "800") {
       addDateFinToPref(reponse.datas);
       _showMyDialog(reponse.datas);
     }else{
       showToast("Consulter vos sms ou votre profil telaa.",
           duration: 5, gravity: Toast.BOTTOM);
       Navigator.pushReplacementNamed(context, '/home');
     }
   }

  Future<void> _showMyDialog(String datefin) async {

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Paiement'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Paiement effectué avec succès'),
                Text('Votre nouveau abonnement prend fin ' +datefin),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Container(
                  decoration: new BoxDecoration(
                    color: primaryColor,
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'OK, Merci',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    Timer(Duration(seconds: 15), () => checkpaiement());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          "Paiement en cours",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        )),
      ),
      body: Center(
          child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            Center(
              child: Text(
                "Paiement en cours patientez  ",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: secondaryColor,

                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
           isloading? Center(child: CircularProgressIndicator()):
           Center(
             child: FlatButton(
               color: secondaryColor,
               textColor: Colors.white,
              // disabledColor: Colors.grey,
             //  disabledTextColor: Colors.black,
               padding: EdgeInsets.all(10.0),
               splashColor: Colors.blueAccent,
               onPressed: () {
                 checkpaiementSecond();
               },
               child: Text(
                 "Verifer le paiement",
                 style: TextStyle(fontSize: 20.0),
               ),
             ),
           )
          ],
        ),
      )),
    );
  }
}
