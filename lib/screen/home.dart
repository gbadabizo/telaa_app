import 'package:connectivity/connectivity.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:telaa_app/models/Reponse.dart';
import 'package:telaa_app/models/client.dart';

import 'package:telaa_app/screen/commandes.dart';
import 'package:telaa_app/screen/common/ClientListTile.dart';

import 'package:telaa_app/screen/common/email_fab.dart';
import 'package:telaa_app/screen/infos.dart';
import 'package:telaa_app/screen/profile.dart';
import 'package:telaa_app/services/telaaService.dart';
import 'package:telaa_app/services/telaa_provider.dart';
import 'package:telaa_app/styleguide/colors.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TelaaService telaaService = TelaaService();
  bool isloading = true;
  final List<Color> _colors = <Color>[
    Colors.green,
    Colors.redAccent,
    Colors.pink,
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.teal,
    Colors.cyan,
    Colors.lightGreen,
    Colors.black26
  ];
  List<Client> _clients = [];
  List<Client> _clientsDisplay = [];

  Future<void> _showMyDialog(String jour) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rappel Abonnement'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Votre abonnement prendra fin'),
                Text('dans ' + jour + 'jours'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Container(
                  decoration: new BoxDecoration(
                    color: primaryColor,
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'OK, Merci',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
              onPressed: () {
                Navigator.of(context).pop();
                //   Navigator.pushReplacementNamed(context, '/home');
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialog2() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Renouveler Abonnement'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Votre abonnement est fini'),
                Text('Prière renouveller'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Container(
                  decoration: new BoxDecoration(
                    color: primaryColor,
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'OK, Merci',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/profile');
              },
            ),
          ],
        );
      },
    );
  }

  _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    print(result.toString());
    if (result == ConnectivityResult.none) {
    } else if (result == ConnectivityResult.mobile) {
      getRemoteDatefin();
    } else if (result == ConnectivityResult.wifi) {
      getRemoteDatefin();
    }
  }

  getRemoteDatefin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String idatelier = prefs.getString("idAtelier");
    Reponse rep = await telaaService.CheckAbonnement(idatelier);
    if (rep.code == "800") {
      prefs.setString("datefin", rep.datas);

    }
  }

  checkAbonnement() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String datefin = prefs.getString("datefin");
    DateTime todayDate = DateTime.now();
    DateTime datefinabn = DateTime.parse(datefin);
    var diff = datefinabn.difference(todayDate);
    // print(diff.inDays);
    if ((diff.inDays <= 5) && (diff.inDays > 0)) {
      _showMyDialog(diff.inDays.toString());
    } else if (diff.inDays == 0) {
      _showMyDialog(diff.inDays.toString());
    } else if (diff.inDays < 0) {
      _showMyDialog2();
    }
  }

  @override
  void initState() {
    _checkInternetConnectivity();
    checkAbonnement();
    setState(() {
      _clients = [];
      _clientsDisplay = [];
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: EmailFAB(
        onPressed: () {
          setState(() {});
        },
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
            child: Text(
          "Bienvenue sur Télaa ",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        )),
        elevation: 10,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: TelaaProvider.getClientList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // _clients = snapshot.data;

              final cls = snapshot.data;
              _clients.clear();
              for (var i = 0; i < cls.length; i++) {
                Client cl = Client(
                    idClient: cls[i]['id'].toString(),
                    codeClient: cls[i]['code'],
                    sexe: cls[i]['sexe'],
                    nomComplet: cls[i]['nomcomplet'],
                    telephone1: cls[i]['telephone1'],
                    telephone2: cls[i]['telephone2'],
                    idAtelier: cls[i]['idatelier'].toString(),
                    status: cls[i]['status'].toString());
                _clients.add(cl);
              }
              if (isloading) {
                _clientsDisplay = _clients;
                isloading = false;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Rechercher un client",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              _clientsDisplay = _clients
                                  .where((element) => element.nomComplet
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                                  .toList();
                              print(_clientsDisplay[0].nomComplet);
                            });
                          } else {
                            isloading = true;
                            setState(() {});
                          }
                          // searchOperation(value);
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListView(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      children: _clientsDisplay
                          .map((e) => ClientListTile(
                                client: e,
                                synchronizedClient: () {},
                              ))
                          .toList()),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: primaryColor,
        backgroundColor: Colors.white,
        buttonBackgroundColor: Color(0xFF872954),
        height: 50,
        index: 0,
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
    );
  }
}
