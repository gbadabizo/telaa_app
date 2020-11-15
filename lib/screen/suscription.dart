import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:telaa_app/models/Reponse.dart';
import 'package:telaa_app/models/atelier.dart';
import 'package:telaa_app/screen/confirmation.dart';
import 'package:telaa_app/services/telaaService.dart';
import 'package:telaa_app/styleguide/constants.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:country_pickers/country.dart';
enum ConfirmAction { CANCEL, ACCEPT }

class SuscriptionPage extends StatefulWidget {
  @override
  _SuscriptionPageState createState() => _SuscriptionPageState();
}

class _SuscriptionPageState extends State<SuscriptionPage> {
  final nameformController = TextEditingController();
  final telformController = TextEditingController();
  final villeformController = TextEditingController();
  final quteformController = TextEditingController();
  final TelaaService telaaService = new TelaaService();
  String codephone="228";
  String code;
  String idAtelier;
  bool isloading =false;
  Widget _buildDropdownItem(Country country) => Container(
    child: Row(
      children: <Widget>[
        CountryPickerUtils.getDefaultFlagImage(country),
        SizedBox(
          width: 8.0,
        ),
        Text("+${country.phoneCode}(${country.isoCode})"),
      ],
    ),
  );
  Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation de numero'),
          content:
              const Text('Ce numero existe déjà. Etes-vous le propriétaire?'),
          actions: <Widget>[
            FlatButton(
              child: const Text('Non'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: const Text('OUI'),
              onPressed: () async {
                Reponse r = await telaaService.getsms(
                    TelaaService.BASE_URL, idAtelier);
                if (r != null) {
                  code =r.datas.toString();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ConfirmationPage(
                                  code, idAtelier,0)));
                }
              },
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    nameformController.dispose();
    telformController.dispose();
    villeformController.dispose();
    quteformController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Inscription à Télaa"),
      ),
      //backgroundColor: secondColor,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Column(
                children: <Widget>[

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextFormField(
                              controller: nameformController,
                              // maxLength: 25,
                              decoration: const InputDecoration(
                                labelText: 'Nom de l\'atelier',
                                hintText: 'Nom de votre atelier',
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(
                                    color: Colors.black, fontSize: 18.0),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Veuillez saisir le nom de l\'atelier';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                      Container(

                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[

                            Expanded(
                              child: TextFormField(
                                // textAlign: TextAlign.center,
                                controller: telformController,
                                inputFormatters: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(15),
                                  WhitelistingTextInputFormatter.digitsOnly,
                                  BlacklistingTextInputFormatter.singleLineFormatter,
                                ],
                                keyboardType: TextInputType.phone,
                                style: TextStyle(color: Colors.black),
                                decoration: const InputDecoration(
                                  labelText: 'N° Téléphone',
                                  hintText: 'votre numero de telephone',
                                  border: OutlineInputBorder(),
                                  labelStyle:
                                  TextStyle(color: Colors.black, fontSize: 15.0),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Veuillez saisir le numéro';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              // maxLength: 25,
                              controller: villeformController,
                              decoration: const InputDecoration(
                                labelText: 'Ville',
                                hintText: 'la ville où se trouve  l\'atelier',
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(
                                    color: Colors.black, fontSize: 18.0),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Veuillez saisir la ville ';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              // maxLength: 25,
                              controller: quteformController,
                              decoration: const InputDecoration(
                                labelText: 'Quartier',
                                hintText:
                                    'le quartier où se trouve  le quartier',
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(
                                    color: Colors.black, fontSize: 18.0),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Veuillez saisir le quartier';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RaisedButton(
                              elevation: 5.0,
                              onPressed: () async {
                                setState(() {
                                  isloading=true ;
                                });
                                if (_formKey.currentState.validate()) {
                                  Atelier atelier = new Atelier(
                                      nom: nameformController.text,
                                      telephone: codephone+""+telformController.text,
                                      ville: villeformController.text,
                                      quartier: quteformController.text);
                                  Reponse rep = await telaaService
                                      .subscribeAtelier(TelaaService.SERVER_URL,
                                          body: atelier.tomap());
                                  if (rep.code == '802') {
                                   // print(rep.datas);
                                    idAtelier = rep.datas.toString();
                                    _asyncConfirmDialog(context);
                                  } else if (rep.code == "800") {
                                    idAtelier=rep.datas.toString();
                                    Reponse r = await telaaService.getsms(
                                        TelaaService.BASE_URL, idAtelier);
                                    if (r != null) {
                                      code =r.datas.toString();
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ConfirmationPage(
                                                      code, idAtelier, 1)
                                          )
                                      );
                                    }
                                  }
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
                                    FontAwesomeIcons.save,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Enregistrer',
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
                          ]),
                    ),
                  ),
                  isloading? CircularProgressIndicator(backgroundColor: primaryColor,):Text(""),
                  new Container(
                      width: 150.0,
                      height: 150.0,
                      decoration: new BoxDecoration(
                         shape: BoxShape.circle,
                          image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new AssetImage('assets/images/img-p7.png'),
                          ))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
