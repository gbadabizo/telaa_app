import 'package:flutter/material.dart';
import 'package:telaa_app/models/client.dart';
import 'package:telaa_app/models/mesure.dart';
import 'package:telaa_app/screen/Detail_client.dart';
import 'package:telaa_app/screen/common/mesure_tile.dart';
import 'package:telaa_app/services/telaa_provider.dart';
class AddMesure extends StatefulWidget {
 Client client;

  AddMesure({this.client});

  @override
  _AddMesureState createState() => _AddMesureState();
}

class _AddMesureState extends State<AddMesure> {
  List<Mesure> _mesures;
  List<Mesure> _displaymesures;

  getAllMesures() async {
    final mesures = await TelaaProvider.getMesureList();
    _mesures.clear();
    for (var i = 0; i < mesures.length; i++) {
      print(
        mesures[i]['libelle'],
      );
      Mesure m = Mesure(
          id_mesure: mesures[i]['id_mesure'],
          code: mesures[i]['code'],
          description: mesures[i]['description'],
          libelle: mesures[i]['libelle'],
          status: mesures[i]['status'],
          valeur: mesures[i]['valeur']);
      _mesures.add(m);
    }
    _displaymesures = _mesures;
    setState(() {

    });
  }

  @override
  void initState() {
    _mesures = [];
    _displaymesures = [];
    getAllMesures();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return
      WillPopScope(
        onWillPop: () {
          return     Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => ClientDetail(client: widget.client)));
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Ajouter les mesures",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Rechercher une mesure",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            _displaymesures = _mesures
                                .where((element) =>
                                element.libelle
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          });
                          // searchOperation(value);
                        }else{
                        setState(() {});
                        }

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
                    children: _displaymesures
                        .map((Mesure m) => MesureTile(
                              mesure: m,client: widget.client,
                            ))
                        .toList()
                )
              ],
            ),
          ),

    ),
      );

  }
}
