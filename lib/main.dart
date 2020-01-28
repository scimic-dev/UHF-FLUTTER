//import 'dart:html';


import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:postgres/postgres.dart';
import 'package:uhfapp/productD.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UHF APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'UHF APP'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PermissionStatus _status;

  Almacen dropdownValue;

  //final FocusNode _focusNode = FocusNode();
  //String _message;
 
  Future<List<String>> data;
  List<Almacen> itemdrop = [];
  //Future _future;
  var estadoFE;
  //Permission permiso;

  @override
 void initState() {
    super.initState();

    //_focusNode.dispose();
    //con = Connection();
    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage)
        .then(_updateStatus);
    startPermision();
    //itemdrop=data;
    //almacenes();
    //print("INICIALIZANDOOOOOOOO");
    //getpermision();
  }

  void _updateStatus(PermissionStatus status) {
    if (status != _status) {
      setState(() {
        _status = status;
      });
    }
  }

  void startPermision() {
    PermissionHandler()
        .requestPermissions([PermissionGroup.storage]).then(_onStatusRequest);
  }

  void _onStatusRequest(Map<PermissionGroup, PermissionStatus> statuss) {
    final status = statuss[PermissionGroup.storage];
    _updateStatus(status);
  }

  @override
  Widget build(BuildContext context) {
    //final TextTheme textTheme = Theme.of(context).textTheme;
    return new MaterialApp(
      
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
          title: Text("Almacen"),
          centerTitle: true,
          elevation: 15,
          
        ),
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,

        body: FutureBuilder(
          future: almacenes(),
          builder:(context, snapshot){
            if(snapshot.data==null){
              return Center(child: new CircularProgressIndicator(),);
            }
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index){
                return Card(
                  elevation: 8.0,
                  margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  child: Container(
                     decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9),borderRadius:BorderRadius.circular(4.0) ),
                     child: ListTile(
                        
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                        leading: Container(
                          padding: EdgeInsets.only(right: 12.0),
                          decoration: new BoxDecoration(
                            border: new Border(
                             right: new BorderSide(width: 1.0, color: Colors.white24))),
                          child: Icon(Icons.tab,color: Colors.white,),
                        ),
                        title: Text(snapshot.data[index].almacen.toString(),style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold),),
                        subtitle: Row(
                          children: <Widget>[
                            Icon(Icons.linear_scale, color: Colors.redAccent),
                            Text(snapshot.data[index].local.toString(), style: TextStyle(color: Colors.white))
                          ],
                        ),
                        trailing: Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
                        onTap: (){
                         ViewCompare d=new ViewCompare(snapshot.data[index].id.toString());
                            d.initState();
                            
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>d));
                       
                        },
                     ),
                  )

                );
              },
            );
          },
        ),

      
      
      ),
    );
  }

  Future<List<Almacen>> almacenes() async {
   var connection = new PostgreSQLConnection("192.168.1.25", 5432, "posperu2",
        username: "postgres", password: "cildgbhiegbbile");
    await connection.open();
    String query =
        "select stk_almacen.id,stk_almacen.almacen,stk_local.nombre from stk_almacen,stk_local where stk_almacen.tipo=1 and stk_almacen.local=stk_local.id";
    List<List<dynamic>> result = await connection
        .query(query)
        .catchError((e) => print(e))
        .whenComplete(() => connection.close());
    List<Almacen> data = [];
    for (final row in result) {
      Almacen almacendata = new Almacen(row[0].toString(), row[1],row[2]);
     
      itemdrop.add(almacendata);
      data.add(almacendata);
    }

    //=data;

    return data;
  }

 
}



class Almacen {
  String id;
  String almacen;
   String local;
  Almacen(this.id, this.almacen,this.local);
}
