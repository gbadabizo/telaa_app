import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:telaa_app/models/client.dart';
import 'package:telaa_app/models/commande.dart';
import 'package:telaa_app/screen/add_commande.dart';
import 'package:telaa_app/screen/detail_commande.dart';
import 'package:telaa_app/screen/home.dart';
import 'package:telaa_app/services/telaa_provider.dart';
import 'package:telaa_app/styleguide/colors.dart';

class CommandeClient extends StatefulWidget {
  Client client;

  CommandeClient(this.client);

  @override
  _CommandeClientState createState() => _CommandeClientState();
}

class _CommandeClientState extends State<CommandeClient> {
  List<Commande> commandes = [];
  getAllCommandes() async {
    final cmds = await TelaaProvider.getCmdListByClient(
       widget.client.codeClient);
   // print(cmds);
    commandes.clear();
    for (var i = 0; i < cmds.length; i++) {
      print(
        cmds[i]['type'],
      );
      Commande cmd = Commande(
          code_client: cmds[i]["code_client"],
          code: cmds[i]["code"],
          type: cmds[i]["type"],
          datecmd: cmds[i]["datecmd"],
          datelivr: cmds[i]["datelivr"],
          id_commande: cmds[i]["id_commande"],
          imagecmd: cmds[i]["imagecmd"],
          montantavance: cmds[i]["montantavance"],
          montanttotal: cmds[i]["montanttotal"],
          status: cmds[i]["status"]);
      commandes.add(cmd);
    }
    setState(() {});
  }

  @override
  void initState() {
    getAllCommandes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
        onWillPop: () {
          return Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage()));
        },
        child: Scaffold(

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddCommande(client: widget.client,cmdMode: CmdMode.Adding,)));
          },
          child: Icon(Icons.add),
          backgroundColor: secondaryColor,
        ),
        appBar: AppBar(
          title: Center(
              child: Text(
            "Liste des commandes",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          )),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
                          "Les commandes de - " + widget.client.nomComplet,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )),
              commandes.length > 0
                  ? ListView(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      children:
                          commandes.map((Commande m) => getCommand(m)).toList())
                  : Center(
                      child: Text(
                        "Pas de commande",
                        style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    )
            ],
          ),
        ),
    ),
      );
  }

  Widget getCommand(Commande cmd) {
    return
      GestureDetector(
        onTap: (){
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => DetailCommande(commande: cmd,)));
        },
        child: Card(
        color: Color(0xFF079992),
        child: ListTile(
          leading: cmd.imagecmd!=null
              ? Container(
              height: 100,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: Image.memory(
                Base64Decoder().convert(cmd.imagecmd),
                fit: BoxFit.fitWidth,
              ))//Image.memory(Base64Decoder().convert(cmd.imagecmd), fit: BoxFit.fitWidth)
              : Container(
                  height: 100,
                  width: 80,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: new AssetImage("assets/images/img-p6.png"),
                      fit: BoxFit.fitWidth,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                ),
          /*  CircleAvatar(
            backgroundImage: new AssetImage('assets/images/img-p5.png',),
          ),*/
          title: Text(
            '' + cmd.type,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                decoration: new BoxDecoration(
                  color: Color(0xFF872954),
                  borderRadius: new BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "A livrer le : " + cmd.datelivr,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          trailing: (cmd.status == 1)
              ? Icon(
                  FontAwesomeIcons.thumbsUp,
                  size: 45,
                  color: Colors.white,
                )
              : Icon(
                  //  FontAwesomeIcons.thumbsUp,
                  FontAwesomeIcons.exclamationCircle,
                  size: 45,
                  color: Colors.amber,
                ),
          isThreeLine: true,
        ),
    ),
      );
  }
}
