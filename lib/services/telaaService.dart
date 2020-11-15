import 'dart:convert';

import 'package:telaa_app/models/Reponse.dart';
import 'package:http/http.dart' as http;
import 'package:telaa_app/models/client.dart';
import 'package:telaa_app/models/clientMes.dart';
import 'package:telaa_app/models/commande.dart';
import 'package:telaa_app/models/list_abonnement.dart';

class TelaaService {
   static final SERVER_URL = 'http://api.telaa.net:8080/telaa/atelier/add';
  static final BASE_URL =  'http://api.telaa.net:8080/telaa/';


  Future<Reponse> subscribeAtelier(String url, {Map body}) async {
    http.Response response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body)
    );
    if (response != null) {
      Reponse reponse = Reponse.fromJson(json.decode(response.body));
      return reponse;
    } else {
      return null;
    }
  }
  Future<Reponse>sendPay( {Map body}) async{
    String url = BASE_URL+"paiement/add";
    http.Response response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body)
    );
    if (response != null) {
      Reponse reponse = Reponse.fromJson(json.decode(response.body));
      return reponse;
    } else {
      return null;
    }
  }
   Future<Reponse>sendPayForTg( {Map body}) async{
     String url = BASE_URL+"/transactions/add";
     http.Response response = await http.post(url,
         headers: <String, String>{
           'Content-Type': 'application/json; charset=UTF-8',
         },
         body: jsonEncode(body)
     );
     if (response != null) {
       Reponse reponse = Reponse.fromJson(json.decode(response.body));
       return reponse;
     } else {
       return null;
     }
   }

   Future<Reponse> login( String tel) async {
    String  url = BASE_URL+ "atelier/login/" + tel;
     http.Response response = await http.get(url);
     if (response != null) {
       Reponse reponse = Reponse.fromJson(json.decode(response.body));
       return reponse;
     }
     return null;
   }

  Future<Reponse> getsms(String url, String idAtelier) async {
    url += "atelier/sendsms/" + idAtelier;
    http.Response response = await http.get(url);
    if (response != null) {
      Reponse reponse = Reponse.fromJson(json.decode(response.body));
      return reponse;
    }
    return null;
  }

   Future<Reponse> CheckPay(int trans) async {
    String  url =  BASE_URL+"paiement/check/" + trans.toString();
     http.Response response = await http.get(url);
     if (response != null) {
       Reponse reponse = Reponse.fromJson(json.decode(response.body));
       return reponse;
     }
     return null;
   }
   Future<Reponse> CheckAbonnement(String  idatelier) async {
     String  url =  BASE_URL+"/checkAbonnement/" + idatelier;
     http.Response response = await http.get(url);
     if (response != null) {
       Reponse reponse = Reponse.fromJson(json.decode(response.body));
       return reponse;
     }
     return null;
   }


  Future<Reponse> confirmCode(String url, String idAtelier, String code) async {
    url += "atelier/confirm/" + idAtelier + "/" + code;
    http.Response response = await http.get(url);
    if (response != null) {
      Reponse reponse = Reponse.fromJson(json.decode(response.body));
      return reponse;
    }
    return null;
  }

  Future<Reponse> sendBackup(String filename, String table,
      String idatelier) async {
    String url = BASE_URL + "/atelier/backup";
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(
      await http.MultipartFile.fromPath(
          'csvFile',
          filename
      ),
    );
    request.fields['tableName'] = table;
    request.fields['idAtelier'] = idatelier;
    //request.fields.addAll({"tableName": table, "idAtelier":'75'}) ;
    await request.send();
  }

  Future<List<Abonnement>> getAllAbonnement() async {
    String url = BASE_URL + "/abonnements";
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
     List<Abonnement> abns = body.map((dynamic item) =>
          Abonnement.fromJson(item)).toList();
      return abns;
    }
    return null;
  }
  Future<List<Client>> getAllClients(String idatelier)  async{
    String url = BASE_URL + "/restore/clients/"+idatelier ;
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
    List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
   // print(body);
    List<Client> clients = body.map((dynamic item) =>
        Client.fromJson(item)).toList();
    return clients;
  }
     return null ;
  }
  Future<List<ClientMes>> getAllClientMesure(String idatelier) async{
      String url = BASE_URL + "/restore/mesures/"+idatelier ;
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
      List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
     // print(body);
      List<ClientMes> clientmes = body.map((dynamic item) =>
          ClientMes.fromJson(item)).toList();
      return clientmes;
    }
    return null;
    }
  Future<List<Commande>> getAllClientCommandes(String idatelier) async{
    String url = BASE_URL + "/restore/commandes/"+idatelier ;
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
    List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
    List<Commande> commandes = body.map((dynamic item) =>
        Commande.fromJson(item)).toList();

    return commandes;
    }
    return null;
  }
}