import 'package:connectivity/connectivity.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telaa_app/screen/commandes.dart';
import 'package:telaa_app/screen/common/Opaque_image.dart';
import 'package:telaa_app/screen/common/my_info.dart';
import 'package:telaa_app/screen/common/profile_info_big_card.dart';
import 'package:telaa_app/screen/home.dart';
import 'package:telaa_app/screen/infos.dart';
import 'package:telaa_app/screen/paiement.dart';
import 'package:telaa_app/services/telaa_provider.dart';
import 'package:telaa_app/styleguide/colors.dart';
import 'package:telaa_app/styleguide/text_style.dart';
import 'package:intl/intl.dart';
import 'common/card_abonnement.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String nbjour = "0";
  String datefin = "";
  String nomAtelier="";
  int commandeEncous=0;
  int clientsNb =0;

  getNbjours() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    datefin = prefs.getString("datefin");
    DateTime todayDate = DateTime.now();
    DateTime datefinabn = DateTime.parse(datefin);
    var nb = datefinabn.difference(todayDate);
    if (nb.inDays > 0) nbjour = nb.inDays.toString();
    setState(() {});
  }
  getNomAtelier() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    nomAtelier =prefs.getString("nomAtelier");
    setState(() {

    });
  }
  _checkInternetConnectivity(int type) async {
    var result = await Connectivity().checkConnectivity();
    print(result.toString());
    if (result == ConnectivityResult.none) {
      _showMyDialog();
    } else if (result == ConnectivityResult.mobile) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Paiement(type)));
    } else if (result == ConnectivityResult.wifi) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Paiement(type)));
    }
  }
  getClientsNb() async{
    clientsNb = await  TelaaProvider.getCountClients();
    setState(() {

    });
  }
  getCommande()async {
    commandeEncous = await TelaaProvider.getCountCmdCours();
    setState(() {

    });
  }
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Connexion Test'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Verifier votre connexion internet'),
                Text(''),
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

  @override
  void initState() {
    getNbjours();
    getNomAtelier();
    getClientsNb();
    getCommande();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          "Mon profil",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        )),
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: CurvedNavigationBar(
        color: primaryColor,
        backgroundColor: Colors.white,
        buttonBackgroundColor: Color(0xFF872954),
        height: 50,
        index: 2,
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          verticalDirection: VerticalDirection.down,

          children: <Widget>[
            SafeArea(
             // flex: 4,
              child: Container(
                height: MediaQuery.of(context).size.height/3,
                width: MediaQuery.of(context).size.width,
                color: primaryColor,
                child: Stack(
                  children: <Widget>[
                    OpaqueImage("assets/images/img-p2.png"),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                ""+nomAtelier,
                                textAlign: TextAlign.left,
                                style: headingTextStyle,
                              ),
                            ),
                            MyInfo(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SafeArea(
              //flex: 5,
              child: Container(
                color: Colors.white,
                child: Table(
                  children: [
                    TableRow(
                        children: [
                          ProfileInfoBigCard(
                            ""+clientsNb.toString()+" clients",
                            " enregistrés",
                            Icon(FontAwesomeIcons.users, size: 20, color: tertiaryColor,),
                          ),
                          ProfileInfoBigCard(
                            ""+commandeEncous.toString()+" commandes",
                            "en cours",
                            Icon(FontAwesomeIcons.syncAlt, size: 20, color: Colors.green,),
                          )

                        ]
                    ),

                    TableRow(
                        children: [
                          GestureDetector(
                            child: CardAbonnement("Abonnement via ",
                                Image.asset("assets/images/flooz.jpg", height: 60,)
                            ),
                            onTap: (){
                              _checkInternetConnectivity(1);
                            },
                          ),

                          GestureDetector(
                            child: CardAbonnement("Abonnement via ",
                                Image.asset("assets/images/tmoney.jpg",height: 60,)
                            ),
                            onTap: (){
                              _checkInternetConnectivity(2);
                            },
                          ),


                        ]
                    ),
                    TableRow(
                        children: [
                          ProfileInfoBigCard(
                            "Expire",
                            "le "+new DateFormat("dd-MM-yyyy").format(DateTime.parse(datefin)),
                               /* +DateTime.parse(datefin).day.toString()+"/"+
                                DateTime.parse(datefin).month.toString()+"/"+
                                DateTime.parse(datefin).year.toString(),*/
                            Icon(FontAwesomeIcons.clock, size: 20, color: Colors.red,),
                          ),
                          ProfileInfoBigCard(
                            "Expire  ",
                            "dans "+nbjour+" jours",
                            Icon(FontAwesomeIcons.hourglassHalf, size: 20, color: Colors.green,),
                          )


                        ]
                    ),

                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
