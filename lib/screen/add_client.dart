import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telaa_app/models/client.dart';
import 'package:telaa_app/screen/Detail_client.dart';
import 'package:telaa_app/screen/home.dart';
import 'package:telaa_app/services/telaa_provider.dart';
import 'package:telaa_app/styleguide/constants.dart';
import 'package:telaa_app/utilities/utility.dart';
import 'package:toast/toast.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:country_pickers/country.dart';

enum ClientMode { Editing, Adding }

class AddClientPage extends StatefulWidget {
  final ClientMode _clientMode;
  final Client client;

  AddClientPage(this._clientMode, this.client);

  @override
  _AddClientPageState createState() => _AddClientPageState();
}

class _AddClientPageState extends State<AddClientPage> {
  final nameformController = TextEditingController();

  final tel1formController = TextEditingController();

  final tel2formController = TextEditingController();
  final codeformController = TextEditingController();
  String codephone = "228";
  int _radioValue = 0;
  String idAtelier = "";
  final _formKey = GlobalKey<FormState>();
  getSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    idAtelier = prefs.getString("idAtelier");
    print("idatelier:" + idAtelier);
  }

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
  @override
  void didChangeDependencies() {

    if (widget._clientMode == ClientMode.Editing) {
      print(widget.client.sexe);
      nameformController.text =  widget.client.nomComplet;
      tel1formController.text = widget.client.telephone1.substring(3);
      tel2formController.text = widget.client.telephone2.substring(3);
      codeformController.text=  widget.client.codeClient;
    }
    super.didChangeDependencies();
  }

  void showToast(
    String msg, {
    int duration,
    int gravity,
  }) {
    Toast.show(msg, context,
        duration: duration,
        gravity: gravity,
        backgroundColor: primaryColor,
        textColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          widget._clientMode == ClientMode.Adding
              ? 'Ajouter un client'
              : 'Modifier un client',
          style: kLabelStyle,
        ),
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
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(20),
                              ],
                              // maxLength: 25,
                              decoration: const InputDecoration(
                                labelText: 'Nom du client',
                                hintText: 'Nom complet du client',
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(
                                    color: Colors.black, fontSize: 18.0),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Veuillez saisir du client';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    child: CountryPickerDropdown(
                                      initialValue: 'TG',
                                      itemBuilder: _buildDropdownItem,
                                      //  itemFilter:  ['AR', 'DE', 'GB', 'CN'].contains(c.isoCode),
                                      priorityList: [
                                        CountryPickerUtils.getCountryByIsoCode(
                                            'GB'),
                                        CountryPickerUtils.getCountryByIsoCode(
                                            'CN'),
                                      ],
                                      sortComparator: (Country a, Country b) =>
                                          a.isoCode.compareTo(b.isoCode),
                                      onValuePicked: (Country country) {
                                        print("Pays :${country.phoneCode}");
                                        codephone = country.phoneCode;
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      // textAlign: TextAlign.center,
                                      controller: tel1formController,
                                      inputFormatters: <TextInputFormatter>[
                                        LengthLimitingTextInputFormatter(15),
                                        WhitelistingTextInputFormatter
                                            .digitsOnly,
                                        BlacklistingTextInputFormatter
                                            .singleLineFormatter,
                                      ],
                                      keyboardType: TextInputType.phone,
                                      style: TextStyle(color: Colors.black),
                                      decoration: const InputDecoration(
                                        labelText:
                                            'Premier numéro de Téléphone',
                                        hintText: 'Premier numéro de Téléphone',
                                        border: OutlineInputBorder(),
                                        labelStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.0),
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
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    child: CountryPickerDropdown(
                                      initialValue: 'TG',
                                      itemBuilder: _buildDropdownItem,
                                      //  itemFilter:  ['AR', 'DE', 'GB', 'CN'].contains(c.isoCode),
                                      priorityList: [
                                        CountryPickerUtils.getCountryByIsoCode(
                                            'GB'),
                                        CountryPickerUtils.getCountryByIsoCode(
                                            'CN'),
                                      ],
                                      sortComparator: (Country a, Country b) =>
                                          a.isoCode.compareTo(b.isoCode),
                                      onValuePicked: (Country country) {
                                        print("Pays :${country.phoneCode}");
                                        codephone = country.phoneCode;
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      // textAlign: TextAlign.center,
                                      controller: tel2formController,
                                      inputFormatters: <TextInputFormatter>[
                                        LengthLimitingTextInputFormatter(15),
                                        WhitelistingTextInputFormatter
                                            .digitsOnly,
                                        BlacklistingTextInputFormatter
                                            .singleLineFormatter,
                                      ],
                                      keyboardType: TextInputType.phone,
                                      style: TextStyle(color: Colors.black),
                                      decoration: const InputDecoration(
                                        labelText: 'Second numéro de Téléphone',
                                        hintText: 'Second numéro de Téléphone',
                                        border: OutlineInputBorder(),
                                        labelStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            widget._clientMode==ClientMode.Editing? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        new Radio(
                                            value: widget.client.sexe=='Masculin' ? 0 :1,
                                            groupValue: _radioValue,
                                            onChanged:
                                                _handleRadioValueChange1),
                                        new Text(
                                          "Homme",
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        new Radio(
                                            value: widget.client.sexe=='Feminin' ? 0 :1,
                                            groupValue: _radioValue,
                                            onChanged:
                                                _handleRadioValueChange1),
                                        new Text(
                                          "Femme",
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ):Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        new Radio(
                                            value: 0,
                                            groupValue: _radioValue,
                                            onChanged:
                                            _handleRadioValueChange1),
                                        new Text(
                                          "Homme",
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        new Radio(
                                            value: 1,
                                            groupValue: _radioValue,
                                            onChanged:
                                            _handleRadioValueChange1),
                                        new Text(
                                          "Femme",
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            RaisedButton(
                              elevation: 5.0,
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  final nomcomplet = nameformController.text;
                                  final tel1 =
                                      codephone + "" + tel1formController.text;
                                  final tel2 =
                                      codephone + "" + tel2formController.text;
                                  String sexe = "";
                                  if (_radioValue == 0) {
                                    sexe = "Masculin";
                                  } else {
                                    sexe = "Feminin";
                                  }
                                  if (widget._clientMode == ClientMode.Adding) {
                                    String code =
                                        Utility.getRandomCode(nomcomplet);
                                    TelaaProvider.insertClient({
                                      'nomcomplet': nomcomplet,
                                      'code': code,
                                      'sexe': sexe,
                                      'telephone1': tel1,
                                      'telephone2': tel2,
                                      'status': 0,
                                      'idatelier': idAtelier
                                    }).then((value) => {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ClientDetail(
                                                          client: new Client(
                                                              idClient: value
                                                                  .toString(),
                                                              nomComplet:
                                                                  nomcomplet,
                                                              codeClient: code,
                                                              sexe: sexe,
                                                              telephone1: tel1,
                                                              telephone2: tel2,
                                                              idAtelier:
                                                                  idAtelier,
                                                              status: '0'))))
                                        });
                                    showToast("Enregistrement effectué",
                                        duration: 2, gravity: Toast.CENTER);
                                  } else if (widget._clientMode == ClientMode.Editing) {
                                    TelaaProvider.updateClient({
                                      'id': widget.client.idClient,
                                      'code': widget.client.codeClient,
                                      'sexe': sexe,
                                      'nomcomplet': nomcomplet,
                                      'telephone1': tel1,
                                      'telephone2': tel2,
                                      'status': 0,
                                      'idatelier': idAtelier
                                    }).then((value) => {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomePage()))
                                    });
                                    showToast("Mis à jour  effectué",
                                        duration: 3, gravity: Toast.CENTER);
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
                  new Container(
                      width: 320,
                      height: 270.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new AssetImage('assets/images/img-p5.png'),
                          ))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleRadioValueChange1(int value) {
    setState(() {
      _radioValue = value;
    });
  }
}
