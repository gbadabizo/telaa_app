import 'dart:async';

import 'package:flutter/material.dart';
import 'package:telaa_app/models/client.dart';
import 'package:telaa_app/models/mesure.dart';
import 'package:flutter/services.dart';
import 'package:telaa_app/services/telaa_provider.dart';
import 'package:telaa_app/styleguide/colors.dart';
import 'package:toast/toast.dart';
class MesureTile extends StatefulWidget {
  Mesure mesure ;
  Client client ;
  MesureTile({this.mesure , this.client});

  @override
  _MesureTileState createState() => _MesureTileState();
}

class _MesureTileState extends State<MesureTile> {
  final _controller = TextEditingController();

  String valMesure="";

  int idmesure ;
  void showToast(String msg, {int duration, int gravity,}) {
    Toast.show(msg, context, duration: duration, gravity: gravity, backgroundColor: primaryColor, textColor: Colors.white);
  }
  addMesure(){
    TelaaProvider.insertMesureClient({
      "valeur": valMesure,
      "code_client": widget.client.codeClient,
      "id_mesure": idmesure
    });
    showToast("Enregistrement effectué", duration: 2,
    gravity: Toast.CENTER);
  }
  @override
  Widget build(BuildContext context) {
    return     Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container
        (
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Expanded(
              child: TextFormField(
                // textAlign: TextAlign.center,
                 //controller:  _controller,
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(4),
                 WhitelistingTextInputFormatter.digitsOnly,
                  BlacklistingTextInputFormatter.singleLineFormatter,
                ],
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.black),
                decoration:  InputDecoration(

                   labelText: ''+widget.mesure.libelle,
                  hintText: ''+widget.mesure.libelle,
                  border: OutlineInputBorder(),

                  labelStyle:
                  TextStyle(color: Colors.black, fontSize: 15.0),
                ),
                initialValue:  widget.mesure.valeur.toString(),
                onChanged:(value){
                  valMesure=value;
                  idmesure= widget.mesure.id_mesure;

                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.save, color: Colors.deepOrange),
              onPressed: () async {
                if(valMesure.isNotEmpty) {
                  final clsmes = await TelaaProvider.getValByClientByMesure(widget.client.codeClient, idmesure);
                  Timer(Duration(milliseconds: 100), (){
                    if (clsmes.length ==0) {
                      addMesure();
                    }
                    setState(() {
                      valMesure="";
                    });
                  });
                }
              },
            ),
          ],
        ),
      ),
    );;
  }
}
