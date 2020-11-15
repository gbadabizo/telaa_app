class ClientMes{
  int id_clientmes;
  String valeur;
  String libelle;
  int id_mesure ;
  String code_client ;

  ClientMes({this.id_clientmes, this.valeur, this.libelle, this.id_mesure,
      this.code_client});
  factory ClientMes.fromJson(Map<String, dynamic>json){
    return ClientMes(
      id_clientmes: json['id_clientmes'],
      id_mesure: json['id_mesure'],
      code_client: json['code'],
      valeur: json['valeur'].toString()
    );
  }
}