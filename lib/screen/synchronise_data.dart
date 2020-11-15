import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telaa_app/models/client.dart';
import 'package:telaa_app/models/clientMes.dart';
import 'package:telaa_app/models/commande.dart';
import 'package:telaa_app/services/telaaService.dart';
import 'package:telaa_app/services/telaa_provider.dart';
import 'package:telaa_app/styleguide/constants.dart';

class SynchroniseData extends StatefulWidget {
  @override
  _SynchroniseDataState createState() => _SynchroniseDataState();
}

class _SynchroniseDataState extends State<SynchroniseData> {
  bool islooding = true;
  String idAtelier;
  TelaaService telaaService = TelaaService();
  List<Client> clients = [];
  List<ClientMes> clientsmes= [];
  List<Commande> commandes = [];
  synchro() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    idAtelier = prefs.getString("idAtelier");
   clients =await telaaService.getAllClients(idAtelier);
   clientsmes = await telaaService.getAllClientMesure(idAtelier);
   commandes = await telaaService.getAllClientCommandes(idAtelier);
    //telaaService.getAllClients(idAtelier);
    setState(() {
     // islooding=false;
    });
  }
  saveClient(){
    if((clients != null)&&(clients.length >0)) {
      print(clients[0].nomComplet);
      clients.forEach((element) {
       if(element != null)
        print("client mesure :"+element.nomComplet+" "+ element.codeClient+" "+element.telephone1);
      Client cl = new Client();
      cl.nomComplet=  element.nomComplet;
      cl.codeClient= element.codeClient;
      cl.sexe=element.sexe;
      cl.telephone1= element.telephone1;
      cl.telephone2=element.telephone2 ;
      cl.status='0';
      cl.idAtelier=idAtelier.toString();
        TelaaProvider.insertClientRecup(cl);
      });
    }
  }
  saveClientMes(){
    if((clientsmes != null) &&(clientsmes.length >0)){
      //print(clientsmes[0].code_client);
      clientsmes.forEach((element) {
        if(element != null) {
          print("client mesure :"+element.code_client+" "+ element.valeur+" "+element.id_mesure.toString());
          TelaaProvider.insertMesureClient({
            "valeur": element.valeur,
            "code_client": element.code_client,
            "id_mesure": element.id_mesure
          });
        }
      });
    }
  }
  saveCommandes(){
    print("commande"+commandes.length.toString());
    if((commandes!= null)&&(commandes.length > 0)) {
      commandes.forEach((element) {
        print(element.code_client);
        TelaaProvider.insertCmd({
          'type': element.type,
          'code': element.code,
          'datecmd': element.datecmd,
          'datelivr': element.datelivr,
          'montanttotal': element.montanttotal,
          'montantavance': element.montantavance,
          'imagecmd': element.imagecmd,
          'code_client': element.code_client,
          'status': 0,
        });
      });
    }
  }
  @override
  void initState() {
      synchro();
      setState(() {

      });
      Timer(
          Duration(seconds: 5),
              () => {
               saveClient(),
               saveClientMes(),
               saveCommandes(),
                Timer(Duration(seconds: 10),()=>{
                  Navigator.pushReplacementNamed(context, '/home'),
                })

          });
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          "Telaa - Data synchro",
          style: TextStyle(fontWeight: FontWeight.w600),
        )),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Text(
                  "Patientez nous recuperons vos données",
                  style: TextStyle(color: primaryColor, fontSize: 14),
                ),
              ),

              islooding? Center(child: CircularProgressIndicator()):
             Text(""),
            ],
          ),
        ),
      ),
    );
  }
}
