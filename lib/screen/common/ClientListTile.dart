import 'dart:math';

import 'package:flutter/material.dart';
import 'package:telaa_app/models/client.dart';
import 'package:telaa_app/screen/Detail_client.dart';
import 'package:telaa_app/styleguide/constants.dart';
import 'package:telaa_app/styleguide/text_style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ClientListTile extends StatelessWidget {
  final Client client;
  final VoidCallback synchronizedClient;
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

  ClientListTile({this.synchronizedClient, @required this.client});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ClientDetail(client: this.client)));
            },
            child: Card(
              elevation: 8,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: CircleAvatar(
                        backgroundColor: _colors[new Random().nextInt(10)],
                        radius: 25.0,
                        child: Text(
                          client?.nomComplet[0] ?? "",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  client?.nomComplet ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .display1
                                      .copyWith(fontSize: 16.0),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  client?.telephone1 ?? "",
                                  style: subTitleStyle2,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        IconButton(
                          icon: (client.status == "0")
                              ? Icon(
                            FontAwesomeIcons.checkCircle,
                            size: 20,
                            color: Colors.green,
                          )
                              : Icon(
                            FontAwesomeIcons.checkCircle,
                            size: 20,
                            color: Colors.greenAccent,
                          ),
                          onPressed: synchronizedClient,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            // child: Divider(height: 5.0,color: primaryColor,),
          )
        ],
      ),
    );
  }
}
