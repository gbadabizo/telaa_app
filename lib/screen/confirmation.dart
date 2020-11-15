import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telaa_app/models/Reponse.dart';
import 'package:telaa_app/services/telaaService.dart';
import 'package:telaa_app/styleguide/constants.dart';

class ConfirmationPage extends StatelessWidget {
  var code;
  final String idAtelier;
  int newAtelier ; // 0 == un ancien atelier , 1 == un nouveau atelier
  TelaaService telaaService = TelaaService();


  ConfirmationPage(this.code, this.idAtelier, this.newAtelier);
  //add connection to shared preference
  addToSF() async{
   SharedPreferences prefs = await SharedPreferences.getInstance();
   prefs.setString("idAtelier", idAtelier);
   prefs.setInt("isPresent", 1);
  }
  addNomToSF(String nomAtelier) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("nomAtelier", nomAtelier);
  }
  final confirmController = TextEditingController();
  final snackBar = SnackBar(
    content: Text(
      'Code incorrect, réessayer',
      style: kLabelStyle,
    ),
    backgroundColor: Colors.red,
    duration: Duration(seconds: 5),
  );
  final snackBar2 = SnackBar(
    content: Text(
      'Erreur serveur, réessayer!!!',
      style: kLabelStyle,
    ),
    backgroundColor: Colors.red,
    duration: Duration(seconds: 5),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Confirmation du numero "),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            new Container(
                margin: const EdgeInsets.only(
                  top: 20,
                ),
                width: 150.0,
                height: 150.0,
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new AssetImage('assets/images/img-p8.png'),
                    ))),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    // textAlign: TextAlign.center,
                    controller: confirmController,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(4),
                      WhitelistingTextInputFormatter.digitsOnly,
                      BlacklistingTextInputFormatter.singleLineFormatter,
                    ],
                    keyboardType: TextInputType.phone,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      labelText: 'Code de confirmation SMS',
                      hintText: 'saisir le code de confirmation envoyé par sms',
                      border: OutlineInputBorder(),
                      labelStyle:
                          TextStyle(color: Colors.black, fontSize: 15.0),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Builder(
                    builder: (context) => RaisedButton(
                      elevation: 5.0,
                      onPressed: () async {

                        String codesaisie = confirmController.text;
                        print("code saisie: "+codesaisie);
                        print("code send: "+code.toString());
                        if (codesaisie.trim() == code.toString().trim()) {
                          Reponse rep = await telaaService.confirmCode(TelaaService.BASE_URL, idAtelier, code);
                          if(rep.code=="800"){
                            addToSF();
                            addNomToSF(rep.datas.toString().trim());
                            if(newAtelier==0) {
                              Navigator.pushReplacementNamed(
                                  context, "/synchro");
                            }
                            else{
                              Navigator.pushReplacementNamed(context, "/home" );
                            }
                          }
                          else{
                            Scaffold.of(context).showSnackBar(snackBar2);
                          }
                        } else {
                          Scaffold.of(context).showSnackBar(snackBar);
                        }
                      },
                      padding: EdgeInsets.all(15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: primaryColor,
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.b,
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.checkCircle,
                            size: 20,
                            color: Colors.white,
                          ),
                          Expanded(
                            child: Text(
                              'Valider',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                  fontSize: 23.0,
                                  fontFamily: 'OpenSans'),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
