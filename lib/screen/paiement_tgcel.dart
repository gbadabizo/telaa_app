import 'dart:async';

import 'package:flutter/material.dart';
import 'package:telaa_app/utilities/utility.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class PaiementTgcel extends StatefulWidget {
 int montant ;
 String codetrans ;
 String  phone ;

 PaiementTgcel({this.montant, this.codetrans, this.phone});

 @override
  _PaiementTgcelState createState() => _PaiementTgcelState();
}

class _PaiementTgcelState extends State<PaiementTgcel> {
 // final Completer<WebViewController> _controller = Completer<WebViewController>();
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  @override
  void dispose() {
    flutterWebViewPlugin.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: 'https://paygateglobal.com/v1/page?token='+Utility.PAYGATE_TOKEN+'&amount='+widget.montant.toString()
          +'&description=Paiement_abonnement&identifier='+widget.codetrans+'&phone='+widget.phone+'&network=TOGOCEL',

    );
  }
}
