class PaiementRequest {
  int idatelier ;
  String numeroTel;
  int idabonnment  ;

  PaiementRequest({this.idatelier, this.numeroTel, this.idabonnment});
  factory PaiementRequest.fromJson(Map<String, dynamic>json){
    return PaiementRequest(
      idatelier: json['idatelier'],
      numeroTel: json['numeroTel'],
      idabonnment: json['idabonnment'],

    );
  }
  Map tomap(){
    var map = new Map<String,dynamic>();
    map["idatelier"] = idatelier ;
    map["numeroTel"]= numeroTel;
    map["idabonnment"]= idabonnment;
    return map;
  }
}