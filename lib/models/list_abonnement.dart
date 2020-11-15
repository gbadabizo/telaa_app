class Abonnement{
  final int idabon ;
  final int duree ;
  final  String libelle ;
  final int status ;
  final String code ;
  final double montant ;

  Abonnement({this.idabon, this.duree, this.libelle, this.status, this.code,
      this.montant});
 Abonnement.fromJson(Map<String, dynamic>json)
    :
      idabon= json['idabon'],
      libelle= json['libelle'],
      duree= json['duree'],
      montant =json['montant'],
      status =json['status'],
      code =json['code']
    ;
  }


