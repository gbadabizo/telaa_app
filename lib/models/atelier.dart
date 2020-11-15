
class Atelier {
  final int  id_atelier;
  final String nom ;
  final String telephone;
  final String ville;
  final String quartier;

  Atelier({this.id_atelier,this.nom, this.telephone, this.ville, this.quartier});

  factory Atelier.fromJson(Map<String, dynamic>json){
    return Atelier(
      id_atelier: json['id_atelier'],
      nom: json['nom'],
      telephone: json['telephone'],
      ville :json['ville'],
      quartier:json['quartier'],
    );
  }
  Map tomap(){
    var map = new Map<String,dynamic>();
    //map["id_atelier"]= id_atelier;
    map["nom"] = nom ;
    map["telephone"]= telephone;
    map["ville"]= ville;
    map["quartier"]= quartier;
    return map;
  }

}