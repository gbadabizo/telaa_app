class Mesure {
 final int id_mesure;
 final String code ;
 final String description;
 final String libelle;
 final int status ;
 final int valeur;


  Mesure({this.id_mesure, this.code, this.description, this.libelle,
      this.status, this.valeur});
 Map tomap(){
   var map = new Map<String,dynamic>();
   map["id_mesure"] = id_mesure ;
   map["code"]= code;
   map["description"]= description;
   map["libelle"]= libelle;
   map["status"]= status;
   map["valeur"]= valeur;

   return map;
 }
}