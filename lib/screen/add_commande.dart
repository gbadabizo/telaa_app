import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:telaa_app/models/client.dart';
import 'package:telaa_app/models/commande.dart';
import 'package:telaa_app/screen/Commandes_client.dart';
import 'package:telaa_app/screen/commandes.dart';
import 'package:telaa_app/screen/detail_commande.dart';
import 'package:telaa_app/screen/home.dart';
import 'package:telaa_app/services/telaa_provider.dart';
import 'package:telaa_app/styleguide/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:telaa_app/utilities/utility.dart';
import 'package:toast/toast.dart';
enum CmdMode { Editing, Adding }

class AddCommande extends StatefulWidget {
  Client client;
  CmdMode cmdMode ;
  Commande commande;
  AddCommande({this.client, this.cmdMode , this.commande});

  @override
  _AddCommandeState createState() => _AddCommandeState();
}

class _AddCommandeState extends State<AddCommande> {
  File file;
  String imagecmd = "";
  String dateCmd= "";
  String dateLivr ="";
  final dateCmdController = TextEditingController();
  final dateLivrController = TextEditingController();
 final mntTotalformController = TextEditingController();
  final mntAvanceformController = TextEditingController();
  final descController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    dateCmdController.dispose();
    dateLivrController.dispose();
    mntTotalformController.dispose();
    mntAvanceformController.dispose();
    descController.dispose();
  }
  @override
  void didChangeDependencies() {

    if (widget.cmdMode == CmdMode.Editing) {
      dateCmdController.text =  widget.commande.datecmd;
      dateLivrController.text = widget.commande.datelivr;
      mntTotalformController.text = widget.commande.montanttotal.toString();
      mntAvanceformController.text=  widget.commande.montantavance.toString();
      descController.text = widget.commande.type;
     // file = Utility.imageFromBase64String(widget.commande.imagecmd);
      imagecmd = widget.commande.imagecmd;
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

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage()));
        },
        child: Scaffold(
            appBar: AppBar(
                title: Center(
              child: Text(
                "Ajouter une commande",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )),
            body: SingleChildScrollView(
                child: Column(children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      _choose();
                    },
                    child: Text(
                      'Prendre photo du pagne',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: primaryColor,
                  ),
                ],
              ),
              file == null
                  ?
              imagecmd.isEmpty?
              Text('Pas d\'image sélectionnée'):
              Image.memory(
                Base64Decoder()
                    .convert(widget.commande.imagecmd),
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              )
                  : new Container(
                      margin: const EdgeInsets.only(
                        top: 5.0,
                      ),
                      width: 100.0,
                      height: 100.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.file(
                        file,
                        fit: BoxFit.cover,
                      )),
              SizedBox(
                height: 5.0,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        controller: descController,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(30),
                        ],
                        // maxLength: 25,
                        decoration: const InputDecoration(
                          labelText: 'Type de tenue',
                          hintText: 'type de tenue',
                          border: OutlineInputBorder(),
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 15.0),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Veuillez saisir le type de tenue';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      DateTimeField(
                        controller: dateCmdController,
                        format: DateFormat("dd-MM-yyyy"),
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2100));
                        },
                        decoration: InputDecoration(
                          labelText: 'Date de Commande',
                          hintText: 'Date de commande',
                          border: OutlineInputBorder(),
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 15.0),
                        ),
                        validator: (value) {
                          if(widget.cmdMode==CmdMode.Editing)
                            value= DateFormat('dd-MM-yyyy').parse(dateCmdController.text);
                          if (value.toIso8601String().isEmpty) {
                            return 'Veuillez saisir la date de la commande';
                          }else if(value.toIso8601String().isNotEmpty){
                            print(value.toIso8601String());
                            dateCmd= value.toIso8601String();
                          }
                          return null;
                        },
                        onChanged: (dt) {},
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      DateTimeField(
                        controller: dateLivrController,
                        format: DateFormat("dd-MM-yyyy"),
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                        },
                        decoration: InputDecoration(
                          labelText: 'Date de livraison',
                          hintText: 'Date de livraison',
                          border: OutlineInputBorder(),
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 15.0),
                        ),
                        validator: (value) {
                          if(widget.cmdMode==CmdMode.Editing)
                            value= DateFormat('dd-MM-yyyy').parse(dateLivrController.text);
                          if (value.toIso8601String().isEmpty) {
                            return 'Veuillez saisir la date de livraison';
                          }else if(value.toIso8601String().isNotEmpty){
                            print(value.toIso8601String());
                            dateLivr= value.toIso8601String();
                          }
                          return null;
                        },
                        onChanged: (dt) {},
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        controller: mntTotalformController,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(8),
                          WhitelistingTextInputFormatter.digitsOnly,
                          BlacklistingTextInputFormatter.singleLineFormatter,
                        ],
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          labelText: 'Montant à payer',
                          hintText: 'Montant à payer',
                          border: OutlineInputBorder(),
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 15.0),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        controller: mntAvanceformController,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(8),
                          WhitelistingTextInputFormatter.digitsOnly,
                          BlacklistingTextInputFormatter.singleLineFormatter,
                        ],
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          labelText: 'Avance payée',
                          hintText: 'Avance payée',
                          border: OutlineInputBorder(),
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 15.0),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      RaisedButton(
                        elevation: 5.0,
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            if(widget.cmdMode== CmdMode.Adding) {
                              TelaaProvider.insertCmd({
                                'type': descController.text,
                                'code': Utility.generateRandomDigits(7),
                                'datecmd': dateCmdController.text,
                                'datelivr': dateLivrController.text,
                                'montanttotal': mntTotalformController.text
                                    .isNotEmpty
                                    ? mntTotalformController.text
                                    : 0,
                                'montantavance': mntAvanceformController.text
                                    .isNotEmpty
                                    ? mntAvanceformController.text
                                    : 0,
                                'imagecmd': imagecmd.isNotEmpty
                                    ? imagecmd
                                    : null,
                                'code_client': widget.client.codeClient,
                                'status': 0,
                              }).then((value) =>
                              {
                                showToast("Enregistrement effectué",
                                    duration: 2, gravity: Toast.CENTER)
                              });
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CommandeClient(widget.client)));
                            }else {
                              print (descController.text);
                              TelaaProvider.updateCmd({

                                'id_commande': widget.commande.id_commande,
                                'type': descController.text,
                                'code': widget.commande.code,
                                'datecmd': dateCmdController.text,
                                'datelivr': dateLivrController.text,
                                'montanttotal': mntTotalformController.text
                                    .isNotEmpty
                                    ? mntTotalformController.text
                                    : 0,
                                'montantavance': mntAvanceformController.text
                                    .isNotEmpty
                                    ? mntAvanceformController.text
                                    : 0,
                                'imagecmd': imagecmd.isNotEmpty
                                    ? imagecmd
                                    : null,
                                'code_client': widget.commande.code_client,
                                'status': widget.commande.status
                              }).then((value) =>
                              {
                                showToast("Mis à jour effectué",
                                    duration: 2, gravity: Toast.CENTER)
                              });
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CommandesPage()));
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
                    ],
                  ),
                ),
              )
            ]))));
  }

  void _choose() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 20);
    // file = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      file = image;
      imagecmd = Utility.base64String(image.readAsBytesSync());
    });
  }
}
