import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telaa_app/models/client.dart';
import 'package:telaa_app/models/clientMes.dart';
import 'package:telaa_app/models/commande.dart';
import 'package:telaa_app/services/telaaService.dart';
import 'package:telaa_app/services/telaa_provider.dart';

class Utility {
  static String  PAYGATE_TOKEN= "cdd3e901-a942-4a8c-87d7-7f8672883e4f" ;
   static int generateRandomDigits(int n) {
    int m =  pow(10, n - 1);
    return m + new Random().nextInt(9 * m);
  }
  static String getRandomCode(String nom) {
    DateTime now = new DateTime.now();
    Random random = new Random();
    int month = now.month;
    int n = random.nextInt(10);
    String code = nom.substring(0, 2)+n.toString()+month.toString();
    int m = random.nextInt(10);
    if (code.length < 5) code = code + m.toString();
    return code.toUpperCase();
  }

  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
    );
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

  static Future<String> generateCsvClient() async {

    var cls = await TelaaProvider.findAll(tableName: "clients");
    List<Client> _clients = [];
    for (var i = 0; i < cls.length; i++) {
      Client cl = Client(
          idClient: cls[i]['id'].toString(),
          codeClient: cls[i]['code'],
          sexe: cls[i]['sexe'],
          nomComplet: cls[i]['nomcomplet'],
          telephone1: cls[i]['telephone1'],
          telephone2: cls[i]['telephone2'],
          status: cls[i]['status'].toString());
      _clients.add(cl);
    }
    List<List<String>> csvClient = [
      <String>[
        'idclient',
        'code',
        'sexe',
        'nomcomplet',
        'telephone1',
        'telephone2',
        'status',

      ],
      ..._clients.map((e) => [
            e.idClient,
            e.codeClient,
            e.sexe,
            e.nomComplet,
            e.telephone1,
            e.telephone2,
            e.status,


          ])
    ];
    String csv = const ListToCsvConverter().convert(csvClient);
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/clients.csv';
    // create File
    final File file = File(path);
    await file.writeAsString(csv);
    return path;
  }
  static Future<String> generateCsvClMesure() async {
    var mes = await TelaaProvider.findAll(tableName: "client_mesure");
    List<ClientMes> _clms = [];
   // print(mes);
    for (var i = 0; i < mes.length; i++) {
      ClientMes m = ClientMes(
          id_mesure: mes[i]['id_mesure'],
          code_client: mes[i]['code_client'],
          valeur: mes[i]['valeur'],
          id_clientmes: mes[i]['id_clientmes']);
      _clms.add(m);
    }
    List<List<String>> csvClientMesure = [
      <String>[
        'id_mesure',
        'code_client',
        'valeur',
        'id_clientmes',
      ],
      ..._clms.map((el) => [
        el.id_mesure.toString(),
        el.code_client,
        el.valeur,
        el.id_clientmes.toString(),
      ])
    ];
    String csv = const ListToCsvConverter().convert(csvClientMesure);
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/clientMesure.csv';
    // create File
    final File file = File(path);
    await file.writeAsString(csv);
    return path;
  }
  static Future<String> generateCsvCmd() async {
    var cmds = await TelaaProvider.findAll(tableName: "commandes");
    List<Commande> _commandes = [];
    for (var i = 0; i < cmds.length; i++) {

      Commande cmd = Commande(
          code_client: cmds[i]["code_client"],
          type: cmds[i]["type"],
          code: cmds[i]["code"],
          datecmd: cmds[i]["datecmd"],
          datelivr: cmds[i]["datelivr"],
          id_commande: cmds[i]["id_commande"],
          imagecmd: cmds[i]["imagecmd"],
          montantavance: cmds[i]["montantavance"],
          montanttotal: cmds[i]["montanttotal"]);

      _commandes.add(cmd);
    }
    List<List<String>> csvClientMesure = [
      <String>[
        'code_client',
        'code_cmd',
        'type',
        'datecmd',
        'datelivr',
        'id_commande',
        'imagecmd',
        'montantavance',
        'montanttotal'
      ],
      ..._commandes.map((el) => [
        el.code_client,
        el.code,
        el.type,
        el.datecmd,
        el.datelivr,
        el.id_commande.toString(),
        el.imagecmd,
        el.montantavance.toString(),
        el.montanttotal.toString(),
      ])
    ];
    String csv = const ListToCsvConverter().convert(csvClientMesure);
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/commandes.csv';
    // create File
    final File file = File(path);
    await file.writeAsString(csv);
    return path;
  }
}
