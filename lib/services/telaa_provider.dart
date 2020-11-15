import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:telaa_app/models/client.dart';

class TelaaProvider {
  static Database db;

  static Future open() async {
    db = await openDatabase(
        join(await getDatabasesPath(), 'telaa.db'),
        version: 1,
        onCreate: (Database db, int version) async {
          db.execute('''
           create table clients(id integer primary key autoincrement,
           
            code text not null, 'nomcomplet' text not null,sexe text not null, telephone1 text not null,
             telephone2 text null, status integer not null, idatelier integer not null);'''
          );
          db.execute('''
           create table mesure(id_mesure integer primary key ,
           
            code text not null, description text not null,genre text  null, libelle text not null,
            status integer not null, valeur integer  null);'''
          );
          db.execute('''
           create table modeles(id_modele integer primary key autoincrement, 
            code_cmd text not null, model_img text not null);'''
          );
          db.execute('''
           create table client_mesure(id_clientmes integer primary key autoincrement ,
           
            valeur text not null, code_client text not null, id_mesure integer not null);'''
          );
          db.execute('''
           create table changes(id_client integer, type integer);'''
          );
          db.execute('''
           create table commandes(id_commande  integer primary key autoincrement, code text not null, type text not null , datecmd text  null,
           datelivr text not null, montanttotal integer null ,montantavance integer null ,  code_client text not null, imagecmd text null, status integer null
           );'''
          );
          String sqlquery="INSERT INTO mesure (id_mesure,code,description,genre,libelle,status,valeur) VALUES (1,'ptr','poitrine','','Poitrine',1,0), (2,'epl','epaule','','Epaule',1,0)"+
              ",(3,'ceint','ceinture','','Ceinture',1,0)  ,(4,'tail','taille','','Taille',1,0) ,(5,'tailh','taille Haute','','Taille Haute',1,0), (6,'tailb','taille basse','','Taille Basse ',1,0)"+
              ",(7,'bass','bassin','','Bassin ',1,0) ,(8,'lg_c','longueur corsage','','Longueur Corsage ',1,0) ,(9,'lg_j','longueur jupe','','Longueur Jupe ',1,0) "+
            ",(10,'lg_m','longueur manche','','Longueur Manche ',1,0), (11,'tr_m','tour manche','','Tour Manche ',1,0) ,(12,'cuis','cuisse','','Cuisse',1,0)"+
              ",(13,'lg_p','longueur patalon','','Longueur Pantalon',1,0), (14,'gn','genoux','','Genoux',1,0) ,(15,'bas','bas','','Bas',1,0) ,(16,'poig','poignet','','Poignet',1,0)"+
              ",(17,'pin','pince','','Pince',1,0), (18,'lg_r','longueur robe','','Longueur Robe',1,0), (19,'cru','carrure dos','','Carrure Dos',1,0), (20,'crud','carrure devant','','Carrure Devant',1,0)"+
              ",(21,'lgd','longueur dos','','Longueur Dos',1,0), (22,'lgde','longueur devant','','Longueur Devant',1,0), (23,'lgc','longueur culotte','','Longueur culotte',1,0), (24,'ven','ventre','','Ventre',1,0)"+
          ",(25,'ha','hanche','','Hanche',1,0)";

        int dbins1= await db.rawInsert(sqlquery);

        }
    );
  }
  static Future<List<Map<String,dynamic>>> getClientList()async{
    if(db==null){
      await open();
    }
    return await db.query('clients',orderBy:'nomcomplet' );
  }
  static Future<int> insertClient(Map<String,dynamic>client )async{
    if(db==null){
      await open();
    }
   return await db.insert('clients', client);
  }
  static Future updateClient(Map<String,dynamic>client) async{
    if(db==null){
      await open();
    }
    await db.update('clients', client,where:'id=?',whereArgs: [client['id']]);
  }
  static Future deleteClient(int id) async {
    if(db==null){
      await open();
    }
    await db.delete('clients',
        where:'id= ? ',
        whereArgs: [id]);
  }
  static Future<List<Map<String,dynamic>>> getMesureList()async{
    if(db==null){
      await open();
    }
    return await db.query('mesure', orderBy: "libelle");
  }
  static Future<List<Map<String,dynamic>>> getMesuresByClient(String code_client)async{
    if(db==null){
      await open();
    }
    return await db.rawQuery('select cm.id_clientmes, cm.valeur , m.libelle , m.id_mesure , cm.code_client from client_mesure cm join mesure m on cm.id_mesure=m.id_mesure where code_client=?', [code_client]);
  }
  static Future insertMesureClient(Map<String,dynamic>clientMesure )async{
    if(db==null){
      await open();
    }
    await db.insert('client_mesure', clientMesure);
  }
  static Future<List<Map<String,dynamic>>> getValByClientByMesure(String code_client , int idmesure)async{
    if(db==null){
      await open();
    }
    return await db.rawQuery('select cm.id_clientmes, cm.valeur  from client_mesure cm join mesure m on cm.id_mesure=m.id_mesure where cm.code_client=? and cm.id_mesure=?', [code_client,idmesure]);
  }
  static Future updateMesureClient(Map<String,dynamic>clientMesure, ) async{
    if(db==null){
      await open();
    }
    await db.update('client_mesure', clientMesure,where:'id_clientmes=?',whereArgs: [clientMesure['id_clientmes']]);
  }
  static Future deleteMesureClient(int id_mesureClient) async {
    if(db==null){
      await open();
    }
    await db.delete('client_mesure',
        where:'id_clientmes= ? ',
        whereArgs: [id_mesureClient]);
  }
  static Future deleteAllMesureClient(String code_client) async {
    if(db==null){
      await open();
    }
    await db.delete('client_mesure',
        where:'code_client= ? ',
        whereArgs: [code_client]);
  }
  static Future<int> insertCmd(Map<String,dynamic>commande )async{
    if(db==null){
      await open();
    }
    return await db.insert('commandes', commande);
  }
  static Future<List<Map<String,dynamic>>> getCmdList()async{
    if(db==null){
      await open();
    }
    return await db.query('commandes',orderBy:'id_commande'+ " DESC" );
  }
  static Future<List<Map<String,dynamic>>> getCmdStatusList( int status)async{
    if(db==null){
      await open();
    }
    return await db.query('commandes', where:'status= ?', whereArgs: [status],orderBy:'id_commande'+ " DESC" );
  }
  static Future<List<Map<String,dynamic>>> getCmdListByClient(String code_client)async{
    if(db==null){
      await open();
    }
    return await db.query('commandes',where: 'code_client=?',whereArgs:[code_client] ,orderBy:'id_commande'+ " DESC" );
  }
  static Future updateCmd(Map<String,dynamic>commande) async{
    if(db==null){
      await open();
    }
    print(commande.toString());
    await db.update('commandes',commande, where:'id_commande=?',whereArgs: [commande['id_commande']]);
  }
  static Future deleteCmd(int id_commande) async {
    if(db==null){
      await open();
    }
    await db.delete('commandes',
        where:'id_commande= ? ',
        whereArgs: [id_commande]);
  }
  static Future<List<Map>> findAll({@required String tableName}) async {
    if(db==null){
      await open();
    }
    return await db.query(tableName);
  }
  static Future<List<Map<String,dynamic>>> getClientByCode(String code)async{
    if(db==null){
      await open();
    }
    return await db.query('clients', where: 'code=?' , whereArgs: [code] );
  }
  static Future<int> insertModele(Map<String,dynamic>modele )async{
    if(db==null){
      await open();
    }
    return await db.insert('modeles', modele);
  }
  static Future deleteModeleByCodeCmd(String  code_commande) async {
    if(db==null){
      await open();
    }
    await db.delete('modeles',
        where:'code_cmd= ? ',
        whereArgs: [code_commande]);
  }
  static Future deleteModeleById(int  id_modele) async {
    if(db==null){
      await open();
    }
    await db.delete('modeles',
        where:'id_modele= ? ',
        whereArgs: [id_modele]);
  }
  static Future<List<Map<String,dynamic>>> getModelByCodeCmd(String code)async{
    if(db==null){
      await open();
    }
    return await db.query('modeles', where: 'code_cmd=?' , whereArgs: [code] );
  }
  static Future<int> getCountClients() async {
    if(db==null){
      await open();
    }
    var x = await db.rawQuery('SELECT COUNT (*) from clients');
        int count = Sqflite.firstIntValue(x);
    return count;
  }
  static  Future<int> getCountCmdCours() async {
    if(db==null){
      await open();
    }
    var x = await db.rawQuery('SELECT COUNT (*) from commandes where status=0');
    int count = Sqflite.firstIntValue(x);
    return count;
  }

  // recuperation  des données depuis le serveur
  static Future<int> insertClientRecup(Client client )async{
    if(db==null){
      await open();
    }
    String sql ="INSERT INTO clients (code, nomcomplet ,sexe , telephone1, telephone2 ,status, idatelier) values(?,?,?,?,?,?,?)";
    return await db.rawInsert(sql,
        [client.codeClient, client.nomComplet, client.sexe,
          client.telephone1, client.telephone2 , int.parse(client.status),
          int.parse(client.idAtelier) ]);
  }
}