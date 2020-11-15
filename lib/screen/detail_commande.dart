import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:telaa_app/models/client.dart';
import 'package:telaa_app/models/commande.dart';
import 'package:telaa_app/models/modeles.dart';
import 'package:telaa_app/screen/Commandes_client.dart';
import 'package:telaa_app/screen/add_commande.dart';
import 'package:telaa_app/screen/commandes.dart';
import 'package:telaa_app/screen/common/Detail_photo.dart';
import 'package:telaa_app/screen/common/card_abonnement.dart';
import 'package:telaa_app/screen/common/card_photo.dart';
import 'package:telaa_app/screen/home.dart';
import 'package:telaa_app/services/telaa_provider.dart';
import 'package:telaa_app/styleguide/colors.dart';
import 'package:telaa_app/utilities/utility.dart';
import 'package:photo_view/photo_view.dart';
import 'package:toast/toast.dart';
enum ConfirmAction { CANCEL, ACCEPT }
class DetailCommande extends StatefulWidget {
  Commande commande;

  DetailCommande({this.commande});

  @override
  _DetailCommandeState createState() => _DetailCommandeState();
}

class _DetailCommandeState extends State<DetailCommande> {
  File file;
  String imageModel;
  Client client;
  Modeles modeles;
  getClients() async {
    //print("commande code :" + widget.commande.code_client);
    final cls =
        await TelaaProvider.getClientByCode(widget.commande.code_client);
   // print(cls.toString());
    for (var i = 0; i < cls.length; i++) {
      client = Client(
          idClient: cls[i]['id'].toString(),
          codeClient: cls[i]['code'],
          sexe: cls[i]['sexe'],
          nomComplet: cls[i]['nomcomplet'],
          telephone1: cls[i]['telephone1'],
          telephone2: cls[i]['telephone2'],
          idAtelier: cls[i]['idatelier'].toString(),
          status: cls[i]['status'].toString());
    }
    setState(() {});
  }

  getModele() async {
    print("code commande: "+ widget.commande.code);
    final mod = await TelaaProvider.getModelByCodeCmd(widget.commande.code);
    print(mod.toString());
    for (var i = 0; i < mod.length; i++) {
      modeles = Modeles(
          id_modele: mod[i]['id_modele'],
          code_cmd: mod[i]['code_cmd'],
          model_img: mod[i]['model_img']);
    }
    setState(() {

    });
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
  Future<ConfirmAction> _asyncConfirmDialog4(
      BuildContext context) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation de livraison'),
          content: const Text('Est-ce que la commande est livrée ?'),
          actions: <Widget>[
            FlatButton(
              child: Container(
                  decoration: new BoxDecoration(
                    color: Colors.grey,
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Non',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
              ),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: Container(
                  decoration: new BoxDecoration(
                    color: primaryColor,
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'OUI',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
              onPressed: () async {
                livrerCmd();
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            )
          ],
        );
      },
    );
  }
  Future<ConfirmAction> _asyncConfirmDialog(
      BuildContext context) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: const Text('Voulez-vous supprimer cette commande?'),
          actions: <Widget>[
            FlatButton(
              child: Container(
                  decoration: new BoxDecoration(
                    color: Colors.grey,
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Non',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: Container(
                  decoration: new BoxDecoration(
                    color: primaryColor,
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'OUI',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
              onPressed: () async {
                TelaaProvider.deleteModeleByCodeCmd(widget.commande.code);
                TelaaProvider.deleteCmd(widget.commande.id_commande).then((value) => {
                  showToast("Suppression effectué avec succès",
                      duration: 2, gravity: Toast.CENTER),
                });
                Navigator.of(context).pop(ConfirmAction.CANCEL);
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => HomePage()));
              },
            )
          ],
        );
      },
    );
  }

  Future<ConfirmAction> _asyncConfirmDialog2(
      BuildContext context) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: const Text('Voulez-vous supprimer ce modele?'),
          actions: <Widget>[
            FlatButton(
              child: Container(
                  decoration: new BoxDecoration(
                    color: Colors.grey,
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Non',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: Container(
                  decoration: new BoxDecoration(
                    color: primaryColor,
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'OUI',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
              onPressed: () async {
                TelaaProvider.deleteModeleById(modeles.id_modele).then((value) => {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => DetailCommande(commande: widget.commande,))),
                  showToast("Suppression effectué avec succès",
                      duration: 2, gravity: Toast.CENTER),
                });
                Navigator.of(context).pop(ConfirmAction.CANCEL);
                setState(() {

                });
               /* Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => HomePage()));*/
              },
            )
          ],
        );
      },
    );
  }

  Future<ConfirmAction> _asyncConfirmDialog3(
      BuildContext context) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: const Text('Voulez-vous supprimer ce modele?'),
          actions: <Widget>[
            FlatButton(
              child: Container(
                  decoration: new BoxDecoration(
                    color: Colors.grey,
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Non',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: Container(
                  decoration: new BoxDecoration(
                    color: primaryColor,
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'OUI',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
              onPressed: () async {
                TelaaProvider.deleteModeleByCodeCmd(widget.commande.code).then((value) => {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => DetailCommande(commande: widget.commande,))),
                  showToast("Suppression effectué avec succès",
                      duration: 2, gravity: Toast.CENTER),
                });
                Navigator.of(context).pop(ConfirmAction.CANCEL);
                setState(() {

                });
                /* Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => HomePage()));*/
              },
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getClients();
    getModele();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child:
          Center(
            child: Text(
              "  Détails de la commande",
              style: TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),

      ),
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.only(bottom: 24),
            width: MediaQuery.of(context).size.width,
            child: Container(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(6),
                        bottomLeft: Radius.circular(6))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: widget.commande.imagecmd != null
                                    ? Image.memory(
                                        Base64Decoder()
                                            .convert(widget.commande.imagecmd),
                                        height: 150,
                                        width: 150,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        height: 150,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: new AssetImage(
                                                "assets/images/img-p6.png"),
                                            fit: BoxFit.fitWidth,
                                          ),
                                          borderRadius:
                                              BorderRadius.all(Radius.circular(4)),
                                        ),
                                      )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                            widget.commande.status==0?  RaisedButton.icon(
                                  color: secondaryColor,
                                  onPressed: () {
                                    _asyncConfirmDialog4(context);
                                  },
                                  icon: Icon(
                                    FontAwesomeIcons
                                        .checkCircle,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  label: Text("")
                              ): Text(""),
                              widget.commande.status==0? RaisedButton.icon(
                                  color: secondaryColor,
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                                        builder: (context) => AddCommande(commande: widget.commande,cmdMode: CmdMode.Editing,)));
                                  },
                                  icon: Icon(
                                    FontAwesomeIcons
                                        .edit,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  label: Text("")
                              ): Text(""),
                              RaisedButton.icon(
                                  color: Colors.red,
                                  onPressed: (){
                                      _asyncConfirmDialog(context);
                                  },
                                  icon: Icon(
                                    FontAwesomeIcons.trashAlt,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  label: Text("")
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    client != null
                        ? Text(
                            "Client : " + client.nomComplet,
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                          )
                        : Text(""),
                    Divider(
                      height: 2,
                      color: secondaryColor,
                    ),
                    Text(
                      "Tenue à coudre : " + widget.commande.type,
                       style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                    Divider(
                      height: 2,
                      color: secondaryColor,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Date de livraison : " + widget.commande.datelivr,
                      maxLines: 2,
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                    Divider(
                      height: 2,
                      color: primaryColor,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Montant total : " +
                          widget.commande.montanttotal.toString(),
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                    Divider(
                      height: 2,
                      color: primaryColor,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Montant avancé : " +
                          widget.commande.montantavance.toString(),
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                    Divider(
                      height: 2,
                      color: primaryColor,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Container(
                      child: Text(
                        "Reste à payer : " +
                            (widget.commande.montanttotal -
                                    widget.commande.montantavance)
                                .toString(),
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Container(
                      child:
                      widget.commande.status==0? Text(
                        "Commande Non livrée "
                            ,
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ): Text(
                        "Commande  livrée "
                        ,
                        style: TextStyle(color: primaryColor, fontSize: 16),
                      ),
                    ),
                    Divider(
                      height: 2,
                      color: primaryColor,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Center(
                          child: Container(
                            decoration: new BoxDecoration(
                              color: secondaryColor,
                              borderRadius: new BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Modèle de la commande ",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )),
                    Divider(
                      height: 5,
                      color: secondaryColor,
                    ),
                    SafeArea(
                      //flex: 5,
                      child:
                      modeles != null ?
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => DetailPhoto(modeles.model_img)));
                              },
                              child: Center(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child:
                                         Image.memory(
                                      Base64Decoder()
                                          .convert(modeles.model_img),
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.cover,
                                    )

                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  RaisedButton.icon(
                                      color: Colors.red,
                                      onPressed: (){
                                        _asyncConfirmDialog2(context);
                                      },
                                      icon: Icon(
                                        FontAwesomeIcons.folderMinus,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      label: Text("")
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                      :
                      Container(
                        color: Colors.white,
                        child: Table(
                          children: [
                            TableRow(children: [
                              file == null
                                  ? GestureDetector(
                                      child: CardPhoto("Ajouter un modèle",
                                        Icon(
                                          FontAwesomeIcons.camera,
                                          size: 50,
                                          color: primaryColor,
                                        ),
                                      ),
                                      onTap: () {
                                        _choose();
                                        setState(() {

                                        });
                                      },
                                    )
                                  : new Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            decoration: new BoxDecoration(
                                                // shape: BoxShape.circle,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            width: double.infinity,
                                            height: 100.0,
                                            child: Image.file(
                                              file,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                                RaisedButton.icon(
                                                  color: Colors.red,
                                                  onPressed: (){
                                                      _asyncConfirmDialog3(context);
                                                  },
                                                  icon: Icon(
                                                    FontAwesomeIcons.folderMinus,
                                                    size: 20,
                                                    color: Colors.white,
                                                  ),
                                                  label: Text("")
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),

                            ]
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  void _choose() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 20);
    // file = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      file = image;
      // String filename = file.path;
      // print(filename);
      imageModel = Utility.base64String(image.readAsBytesSync());
      TelaaProvider.insertModele({
        "code_cmd": widget.commande.code,
        "model_img": imageModel,
      });
    });

  }
  livrerCmd(){
    TelaaProvider.updateCmd({
      'id_commande': widget.commande.id_commande,
      'type': widget.commande.type,
      'code': widget.commande.code,
      'datecmd': widget.commande.datecmd,
      'datelivr': widget.commande.datelivr,
      'montanttotal': widget.commande.montanttotal,
      'montantavance': widget.commande.montantavance,
      'imagecmd':widget.commande.imagecmd,
      'code_client': widget.commande.code_client,
      'status':1,
    }).then((value) => {
      showToast("Commande livrée",
          duration: 2, gravity: Toast.CENTER),
    Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (context) => CommandeClient(client)))
    });

  }

}
