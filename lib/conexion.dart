


import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';      
// import 'dart:io' as io;    

class Connection{

String dataestado="";
static Database _db; 
List<int> ce=[];  

Future<Database> get db async {    
   if (_db != null) {    
     return _db;    
   }    
   _db = await initDatabase();    
   return _db;    
 }    
     
 initDatabase() async {    
   //io.Directory documentDirectory = await getApplicationDocumentsDirectory();    
   //String path = join(documentDirectory.path, 'db_codigos.db');    
   var db = await openDatabase("/storage/emulated/0/uhf/db_codigos.db", version: 1, onCreate: _onCreate);
   //var db = await openDatabase("/data/user/0/com.example.uhfapp/app_flutter/db_codigos.db", version: 1, onCreate: _onCreate);
   //var db = await openDatabase(path, version: 1, onCreate: _onCreate);
   ///data/user/0/com.example.uhfapp/app_flutter/db_codigos.db iniciando base de datos
   //print(path+"   iniciando base de datos");
   return db;    
 }    
     
 _onCreate(Database db, int version) async {    
   await db.execute('CREATE TABLE uhfcode ( code TEXT)');    
 } 

 Future<List<String>> getdatasql() async {    
   var dbClient = await db;    
   List<Map> maps = await dbClient.query('uhfcode', columns: ['code '],distinct: true);    
   List<String> dta = [];    
   if (maps.length > 0) {    
     for (int i = 0; i < maps.length; i++) {
       print(maps[i]["code"]);
       dta.add(maps[i]["code"]);    
     }    
   }

   return dta;    
 }

Future<String>getCount(String code) async {
   
    //database connection
    //print(code);
    String estado="VACIO";
    //code=code.replaceAll("", replace)
    Database db = await this.db;
    var x = await db.rawQuery("SELECT count( DISTINCT code) from uhfcode where code='$code' ");
    int count = Sqflite.firstIntValue(x);
    //print("Cantidad $count" );
    //ce.clear();
    if(count>0){
      dataestado= "ENCONTRADO";
      estado="ENCONTRADO";
     // print("Aqui" );
    }else{
      dataestado= "NO ENCONTRADO";
      estado="NO ENCONTRADO";
     // print(" No Aqui" );
    }
    return estado;
    
}
 

 //Future<bool> 
     
//  Future<int> delete(int id) async {    
//    var dbClient = await db;    
//    return await dbClient.delete(    
//      'student',    
//      where: 'id = ?',    
//      whereArgs: [id],    
//    );    
//  }    
     
//  Future<int> update(Student student) async {    
//    var dbClient = await db;    
//    return await dbClient.update(    
//      'student',    
//      student.toMap(),    
//      where: 'id = ?',    
//      whereArgs: [student.id],    
//    );    
//  }    
     
 Future close() async {    
   var dbClient = await db;    
   dbClient.close();    
 }   

}