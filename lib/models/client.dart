import 'package:flutter/material.dart';

class Client{
  String idClient  ;
  String nomComplet ;
  String codeClient;
  String sexe;
  String telephone1;
  String telephone2;
  String status;
  String idAtelier;

 Client({this.idClient,@required this.codeClient, @required this.nomComplet,
  @required this.sexe, @required this.telephone1, this.telephone2, this.status,  this.idAtelier});

factory Client.fromJson(Map<String, dynamic>json){
  return Client(
   idClient: json['id_client'].toString(),
   nomComplet: json['nomComplet'],
   codeClient: json['code'],
   sexe: json['sexe'],
   telephone1: json['telephone1'],
   telephone2: json['telephone2'],
   status :json['status'].toString(),
  );
 }
 Map tomap(){
  var map = new Map<String,dynamic>();
  //map["id_atelier"]= id_atelier;
  map["nomComplet"] = nomComplet ;
  map["codeClient"]= codeClient;
  map["sexe"]= sexe;
  map["telephone1"]= telephone1;
  map["telephone2"]= telephone2;
  map["idAtelier"]= idAtelier;
  return map;
 }
}