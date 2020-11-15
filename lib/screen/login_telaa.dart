import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:telaa_app/models/Reponse.dart';
import 'package:telaa_app/screen/confirmation.dart';
import 'package:telaa_app/screen/suscription.dart';
import 'package:telaa_app/services/telaaService.dart';
import 'package:telaa_app/styleguide/constants.dart';

class LoginTelaa extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginTelaa> {
  final TelaaService telaaService = new TelaaService();
  String codephone = "228";
  final numphoneController = TextEditingController();
  bool isloading = false;
  Widget _buildTelephoneTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'N° Telephone',
          style: kLabelStyle,
        ),
        SizedBox(
          height: 20.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: numphoneController,
            textAlign: TextAlign.center,
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(8),
              WhitelistingTextInputFormatter.digitsOnly,
              BlacklistingTextInputFormatter.singleLineFormatter,
            ],
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.phone,
                color: primaryColor,
              ),
              hintText: "Entrer votre numero ",
              hintStyle: kHintTextStyle,
              fillColor: primaryColor,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
          elevation: 5.0,
          onPressed: () async {
            setState(() {
              isloading = true;
            });
            String phone = codephone + "" + numphoneController.text;
            Reponse rep = await telaaService.login(phone);

            if (rep.code == "802") {
              String idAtelier = rep.datas.toString();
              Reponse r =
                  await telaaService.getsms(TelaaService.BASE_URL, idAtelier);
              if (r != null) {
                String code = r.datas.toString();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ConfirmationPage(code, idAtelier, 0)));
              }
            } else {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => SuscriptionPage()));
            }
          },
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Colors.white,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.b,
            children: <Widget>[
              Icon(
                FontAwesomeIcons.lock,
                size: 20,
                color: primaryColor,
              ),
              Expanded(
                child: Text(
                  'Connexion',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 1.5,
                      fontSize: 23.0,
                      fontFamily: 'OpenSans'),
                ),
              )
            ],
          )),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => {Navigator.pushNamed(context, '/inscrire')},
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Vous n\'avez pas de compte? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'S\'inscrire',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF1dd1a1),
                      Color(0xFF018285),
                      Color(0xFF018285),
                      Color(0xFF10ac84),
                      //Color(0xFF20b27a),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  )),
                ),
                Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 60.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Espace de Connexion',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        new Container(
                            width: 150.0,
                            height: 150.0,
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new AssetImage(
                                      'assets/images/img-p6.png'),
                                ))),
                        _buildTelephoneTF(),
                        SizedBox(
                          height: 20.0,
                        ),
                        _buildLoginBtn(),
                        _buildSignupBtn(),
                        isloading
                            ? CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              )
                            : Text(""),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
