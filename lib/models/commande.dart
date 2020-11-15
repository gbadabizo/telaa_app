import 'package:flutter/cupertino.dart';

class Commande{
  final int  id_commande  ;
  final String code;
  final String type ;
  final String datecmd;
  final String datelivr;
  final int montanttotal;
  final int  montantavance;
  final String code_client;
  final String imagecmd;
  final int status;

  Commande({this.id_commande, @required this.type, this.datecmd, this.datelivr,
      this.montanttotal, this.montantavance, @required this.code_client, this.imagecmd, this.status, this.code});
  factory Commande.fromJson(Map<String, dynamic>json){
    return Commande(
      id_commande: json['id_commande'],
      code: json['code'],
      type: json['type'],
      datecmd :json['datecmd'],
      datelivr:json['datelivr'],
      montanttotal:json['montanttotal'],
      montantavance:json['montantavance'],
      code_client:json['code_client'],
      imagecmd:json['imagecmd'],
      status:json['status'],
    );
  }
}