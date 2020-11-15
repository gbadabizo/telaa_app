
import 'package:telaa_app/models/atelier.dart';

class Reponse{
  final String code ;
  final String message ;

  final Object datas ;

  Reponse({this.code, this.message, this.datas});

  @override
  String toString() {
    return 'Reponse{code: $code, message: $message, datas: $datas}';
  }

  factory Reponse.fromJson(Map<String, dynamic>json){
    return Reponse(
      code: json['code'],
      message: json['message'],

        datas: json['datas'],
    );
  }

}