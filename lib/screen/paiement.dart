import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:telaa_app/models/Reponse.dart';
import 'package:telaa_app/models/list_abonnement.dart';
import 'package:telaa_app/models/montant_abon.dart';
import 'package:telaa_app/models/paiement_request.dart';
import 'package:telaa_app/screen/paiement_tgcel.dart';
import 'package:telaa_app/screen/wait_paiement.dart';
import 'package:telaa_app/services/telaaService.dart';
import 'package:flutter/services.dart';
import 'dart:math' as Math;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telaa_app/styleguide/constants.dart';
import 'package:toast/toast.dart';

class Paiement extends StatefulWidget {
  int type;

  Paiement(this.type);

  @override
  _PaiementState createState() => _PaiementState();
}

class _PaiementState extends State<Paiement> {
  final telformController = TextEditingController();
  TelaaService telaaService = TelaaService();
  List<MontantAbn> montantIdabn = [];
  final _formKey = GlobalKey<FormState>();
  List<Abonnement> abonnements = new List<Abonnement>();
  int _radioValue = 1;
  String idAtelier = "";
  bool isloading = false;
  bool internetStatus = false;
  getSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    idAtelier = prefs.getString("idAtelier");
    setState(() {});
  }

  _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    print(result.toString());
    if (result == ConnectivityResult.none) {
    } else if (result == ConnectivityResult.mobile) {
      internetStatus = true;
    } else if (result == ConnectivityResult.wifi) {
      internetStatus = true;
    }
  }

  @override
  void dispose() {
    telformController.dispose();
    super.dispose();
  }

  void showToast(
    String msg, {
    int duration,
    int gravity,
  }) {
    Toast.show(msg, context,
        duration: duration,
        gravity: gravity,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white);
  }

  @override
  void initState() {
    getSharedPreference();
    setState(() {
      _checkInternetConnectivity();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Paiement d'abonnement",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      controller: telformController,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(8),
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
                    FutureBuilder(
                        future: telaaService.getAllAbonnement(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Abonnement>> snapshot) {
                          //  print(snapshot);
                          if (snapshot.hasData) {
                            abonnements = snapshot.data;
                            abonnements.forEach((element) {
                              MontantAbn mnt = MontantAbn(
                                  idabn: element.idabon,
                                  montant: element.montant.round());
                              montantIdabn.add(mnt);
                            });
                            // print(abonnements.length);
                            return ListView(
                                shrinkWrap: true,
                                // physics: ClampingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                children: abonnements
                                    .map((Abonnement a) => getRadioButton(a))
                                    .toList());
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                    SizedBox(
                      height: 10.0,
                    ),
                    RaisedButton(
                      elevation: 5.0,
                      onPressed: () async {
                        if (telformController.text.isNotEmpty) {
                          PaiementRequest prq = PaiementRequest(
                              idatelier: int.parse(idAtelier),
                              idabonnment: _radioValue,
                              numeroTel: telformController.text);
                          setState(() {
                            isloading = true;
                          });
                          if(internetStatus){
                          if (widget.type == 1) {
                            Reponse rep =
                                await telaaService.sendPay(body: prq.tomap());
                            if (rep.code == "800") {
                              String idtrans = rep.datas.toString();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          WaitPaiement(int.parse(idtrans))));
                            } else {
                              showToast(
                                  "Echec de paiement verifier votre connexion",
                                  duration: 2,
                                  gravity: Toast.CENTER);
                            }
                          } else if (widget.type == 2) {
                            List<MontantAbn> idabnMontant = montantIdabn
                                .where(
                                    (element) => element.idabn == _radioValue)
                                .toList();
                            print(idabnMontant[0].montant);
                            int montant = idabnMontant[0].montant;
                            Reponse rep = await telaaService.sendPayForTg(
                                body: prq.tomap());
                            if (rep.code == "800") {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PaiementTgcel(
                                            codetrans: rep.datas,
                                            montant: montant,
                                            phone: prq.numeroTel,
                                          )));
                            } else {
                              showToast(
                                  "Echec de paiement verifier votre connexion",
                                  duration: 2,
                                  gravity: Toast.CENTER);
                            }
                          }
                        }else{
                            showToast("Veillez-vous connecter à internet",
                                duration: 3, gravity: Toast.CENTER);
                          }
                        } else {
                          showToast("Veillez saisir un numero de telephone",
                              duration: 3, gravity: Toast.CENTER);
                        }
                      },
                      padding: EdgeInsets.all(15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Color(0xFF872954),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.b,
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.moneyBillAlt,
                            size: 20,
                            color: Colors.white,
                          ),
                          Expanded(
                            child: Text(
                              'Payer',
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
                    SizedBox(
                      height: 10.0,
                    ),
                    Center(
                      child: isloading
                          ? CircularProgressIndicator(
                              backgroundColor: secondColor,
                            )
                          : Text(""),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getRadioButton(Abonnement abn) {
    return Row(
      children: <Widget>[
        new Radio(
            value: abn.idabon,
            groupValue: _radioValue,
            onChanged: _handleRadioValueChange),
        new Text(
          abn.libelle +
              " ( Prix : " +
              abn.montant.round().toString() +
              " FCFA )",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ],
    );
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
    });
  }
}
