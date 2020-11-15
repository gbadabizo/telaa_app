import 'dart:async';

import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:telaa_app/services/telaaService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telaa_app/utilities/utility.dart';

class Parameters extends StatefulWidget {
  @override
  _ParametersState createState() => _ParametersState();
}

class _ParametersState extends State<Parameters> {
  bool internetStatus = false;
  int isPresent = 0;
  String idAtelier = "";

  final TelaaService telaaService = new TelaaService();
  getSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isPresent = prefs.getInt("isPresent");
    if (isPresent == null) isPresent = 0;
    if (isPresent == 1) idAtelier = prefs.getString("idAtelier");
    setState(() {});
  }

  sendBackup() async {
    String path = await Utility.generateCsvClient();
    telaaService.sendBackup(path, "client", idAtelier);
    String path2 = await Utility.generateCsvClMesure();
    telaaService.sendBackup(path2, "client_mesure", idAtelier);
    String path3 = await Utility.generateCsvCmd();
    telaaService.sendBackup(path3, "commandes", idAtelier);
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
    setState(() {});
  }

  getWait() {
    Timer(Duration(seconds: 5), () => {sendBackup()});
  }

  @override
  void initState() {
    getSharedPreference();
    _checkInternetConnectivity();
    if (internetStatus) getWait();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          "sauvegarde en cours ...",
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: internetStatus
          ? Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Sauvegarde en cours ..."),
                  CircularProgressIndicator(),
                ],
              ),
            )
          : Center(
              child: Text("Echec de connexion internet"),
            ),
    );
  }
}
