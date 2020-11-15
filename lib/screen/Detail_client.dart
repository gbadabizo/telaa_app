import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:telaa_app/models/client.dart';
import 'package:telaa_app/models/clientMes.dart';
import 'package:telaa_app/screen/Commandes_client.dart';
import 'package:telaa_app/screen/add_client.dart';
import 'package:telaa_app/screen/add_commande.dart';
import 'package:telaa_app/screen/add_mesure.dart';
import 'package:telaa_app/screen/home.dart';
import 'package:telaa_app/screen/voice_mesure.dart';
import 'package:telaa_app/services/callsms_service.dart';
import 'package:telaa_app/services/service_locator.dart';
import 'package:telaa_app/services/telaa_provider.dart';
import 'package:telaa_app/styleguide/colors.dart';
import 'package:toast/toast.dart';

enum ConfirmAction { CANCEL, ACCEPT }

class ClientDetail extends StatefulWidget {
  Client client;
  ClientDetail({this.client});
  @override
  _ClientDetailState createState() => _ClientDetailState();
}

class _ClientDetailState extends State<ClientDetail> {
  final CallSmsService _service = locator<CallSmsService>();
  List<ClientMes> _mes = [];
  TextEditingController _textFieldController = TextEditingController();
  _displayDialogInput(BuildContext context, ClientMes clm) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Modifier une mesure'),
            content: TextField(
              controller: _textFieldController,
              decoration:
                  InputDecoration(hintText: "Saisir la nouvelle mesure"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: Container(
                    decoration: new BoxDecoration(
                      color: primaryColor,
                      borderRadius: new BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        'Enregistrer',
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
                onPressed: () {
                  TelaaProvider.updateMesureClient({
                    "id_clientmes": clm.id_clientmes,
                    "valeur": _textFieldController.text,
                    "code_client": clm.code_client,
                    "id_mesure": clm.id_mesure
                  }).then((value) => {
                        showToast("Modification effectué avec succès",
                            duration: 2, gravity: Toast.CENTER),
                      });
                  Navigator.of(context).pop(ConfirmAction.CANCEL);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => ClientDetail(
                            client: widget.client,
                          )));
                },
              ),
              new FlatButton(
                child: Container(
                    decoration: new BoxDecoration(
                      color: Colors.grey,
                      borderRadius: new BorderRadius.circular(10),
                    ),
                    child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    'Annuler',
                    style: TextStyle(color: Colors.white),
                  ),
                )),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
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

  Future<ConfirmAction> _asyncConfirmDialog(
      BuildContext context, int id) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: const Text('Voulez-vous supprimer cette mesure?'),
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
                TelaaProvider.deleteMesureClient(id).then((value) => {
                      {
                        {
                          {
                            showToast("Suppression effectué avec succès",
                                duration: 2, gravity: Toast.CENTER),
                          }
                        }
                      }
                    });
                Navigator.of(context).pop(ConfirmAction.CANCEL);
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => ClientDetail(
                          client: widget.client,
                        )));
              },
            )
          ],
        );
      },
    );
  }

  Future<ConfirmAction> _asyncConfirmDialogClient(
      BuildContext context, Client client) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: const Text('Voulez-vous supprimer ce client?'),
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
                TelaaProvider.deleteAllMesureClient(client.codeClient);
                TelaaProvider.deleteClient(int.parse(client.idClient)).then((value) => {
                      {
                        {
                          {
                            showToast("Suppression effectué avec succès",
                                duration: 2, gravity: Toast.CENTER),
                          }
                        }
                      }
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

  Widget displayMesure(ClientMes clm) {
    return Card(
      elevation: 5,
      child: ListTile(
          leading: Text(clm.libelle + ": "),
          title: Text(clm.valeur),
          trailing: Wrap(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.lightBlue,
                ),
                onPressed: () {
                  _displayDialogInput(context, clm);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                ),
                onPressed: () {
                  _asyncConfirmDialog(context, clm.id_clientmes);
                },
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()));
      },
      child: Scaffold(
          /*floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddMesure(client: widget.client)));
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.deepOrangeAccent,
          ),*/
          floatingActionButton: Stack(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(left:31),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: FloatingActionButton(
                  heroTag: 'add',
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddMesure(client: widget.client)));
                  },
                  child: Icon(Icons.add),
                  backgroundColor: Colors.deepOrangeAccent,),
              ),),

            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                heroTag: 'save',
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => VoiceMesure(client: widget.client)));
                },
                child: Icon(Icons.add),
                backgroundColor: Colors.teal,),
            ),
          ],
        ),
          appBar: AppBar(
            title: Center(
              child: Text(
                widget.client.nomComplet,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.assignment),
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => CommandeClient(widget.client)));
                },
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => AddClientPage( ClientMode.Editing,widget.client )));

                },
              ),

              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
                onPressed: () {
                  _asyncConfirmDialogClient(
                      context, widget.client);
                },
              ),
            ],
          ),
          body: FutureBuilder(
              future: TelaaProvider.getMesuresByClient(
                  widget.client.codeClient),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final mes = snapshot.data;
                  for (var i = 0; i < mes.length; i++) {
                    ClientMes m = ClientMes(
                        id_mesure: mes[i]['id_mesure'],
                        libelle: mes[i]['libelle'],
                        code_client: mes[i]['code_client'],
                        valeur: mes[i]['valeur'],
                        id_clientmes: mes[i]['id_clientmes']);
                    _mes.add(m);
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          color: Colors.teal.withOpacity(0.3),
                          //primaryColor.withOpacity(0.3),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(8),
                                  margin: EdgeInsets.all(5),
                                  decoration: new BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: new BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    widget.client?.nomComplet,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  margin: EdgeInsets.all(5),
                                  decoration: new BoxDecoration(
                                    color: Color(0xFF872954),
                                    borderRadius:
                                        new BorderRadius.circular(100),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      FontAwesomeIcons.phoneAlt,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      _service.call(widget.client.telephone1);
                                    },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  margin: EdgeInsets.all(5),
                                  decoration: new BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius:
                                        new BorderRadius.circular(100),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      FontAwesomeIcons.sms,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      _service.sendSms(widget.client.telephone1);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Divider(
                            color: primaryColor,
                            height: 2.0,
                          ),
                        ),
                        _mes.length > 0
                            ? Center(
                                child: Container(
                                  decoration: new BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius: new BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Les mesures enrégistrées",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            : Text(""),
                        _mes.length > 0
                            ? ListView(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                children: _mes
                                    .map((ClientMes m) => displayMesure(m))
                                    .toList(),
                              )
                            : Center(
                                child: Text(
                                  "Pas de mesures veiller enregistrer ...",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })),
    );
  }
}
