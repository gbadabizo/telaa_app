import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:telaa_app/models/commande.dart';
import 'package:telaa_app/screen/detail_commande.dart';
import 'package:telaa_app/screen/home.dart';
import 'package:telaa_app/screen/infos.dart';
import 'package:telaa_app/screen/profile.dart';
import 'package:telaa_app/services/telaa_provider.dart';
import 'package:telaa_app/styleguide/constants.dart';

class CommandesPage extends StatefulWidget {
  @override
  _CommandesPageState createState() => _CommandesPageState();
}

class _CommandesPageState extends State<CommandesPage> {
  List<Commande> commandes_encours = [];
  List<Commande> commandes_livr = [];
  getAllCommandesEnCours() async {
    final cmds = await TelaaProvider.getCmdStatusList(0);
   // print(cmds);
    commandes_encours.clear();
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

      commandes_encours.add(cmd);
    }
    setState(() {});
  }

  getAllCommandesLivr() async {
    final cmds = await TelaaProvider.getCmdStatusList(1);
   // print(cmds);
    commandes_livr.clear();
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
      commandes_livr.add(cmd);
    }
    setState(() {});
  }

  @override
  void initState() {
    getAllCommandesEnCours();
    getAllCommandesLivr();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        //  backgroundColor: Colors.teal,
        appBar: AppBar(
          title: Center(
              child: Text(
            "Les commandes ",
            style: TextStyle(color: Colors.white),
          )),
          bottom: TabBar(
            indicatorColor: Color(0xFF872954),
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  FontAwesomeIcons.exclamationCircle,
                  size: 25,
                  color: Colors.amber,
                ),
                text: "En cours",
              ),
              Tab(
                icon: Icon(
                  FontAwesomeIcons.thumbsUp,
                  size: 25,
                  color: Colors.white,
                ),
                text: "Livrées",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            commandes_encours.length > 0
                ? ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    children: commandes_encours
                        .map((Commande m) => getCommand(m))
                        .toList())
                : Center(
                    child: Text(
                      "Pas de commande en cours",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
            commandes_livr.length > 0
                ? ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    children: commandes_livr
                        .map((Commande m) => getCommand(m))
                        .toList())
                : Center(
                    child: Text(
                      "Pas de commande livrée",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
          ],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          color: primaryColor,
          backgroundColor: Colors.white,
          buttonBackgroundColor: Color(0xFF872954),
          height: 50,
          index: 1,
          items: <Widget>[
            Icon(
              FontAwesomeIcons.home,
              size: 20,
              color: Colors.white,
            ),
            Icon(
              FontAwesomeIcons.shoppingCart,
              size: 20,
              color: Colors.white,
            ),
            Icon(
              FontAwesomeIcons.userCircle,
              size: 20,
              color: Colors.white,
            ),
            Icon(
              FontAwesomeIcons.infoCircle,
              size: 20,
              color: Colors.white,
            ),
          ],
          //  animationDuration: Duration(milliseconds: 200),
          //   animationCurve: Curves.bounceInOut,
          onTap: (index) {
            debugPrint("index du menu $index");
            if (index == 0) {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomePage()));
            }
            if (index == 1) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CommandesPage()));
            }
            if (index == 2) {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ProfilePage()));
            }
            if (index == 3) {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => InfosPage()));
            }
          },
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
          leading:
          /*cmd.imagecmd != null
              ? Container(
                  height: 100,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  child: Image.memory(
                    Base64Decoder().convert(cmd.imagecmd),
                    fit: BoxFit.fitWidth,
                  ))
              : */
          Container(
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
                    "A livré le : " + cmd.datelivr,
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
