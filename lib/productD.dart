import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uhfapp/conexion.dart';

// void main()=> runApp(ViewCompare());
@immutable
class ViewCompare extends StatelessWidget {
  String id_almacen = "1";
  ViewCompare(this.id_almacen);
  String observacion_det = "";

  
  Database database;
  Connection con;

  void initState() {
    con = Connection();
    con.initDatabase();
    //pgdata(id_almacen);

    //datanoencontrado.forEach((f)=>(print(f)));
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: new Scaffold(
          backgroundColor: Color.fromRGBO(58, 66, 86, 1),
          appBar: AppBar(
            leading: InkWell(
              child: Icon(
                Icons.chevron_left,
                color: Colors.white24,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            title: Text("Productos"),
            centerTitle: true,
            backgroundColor: Color.fromRGBO(58, 66, 86, .9),
            bottom: new TabBar(
              tabs: <Widget>[
                new Tab(
                  text: "NO ENCONTRADOS",
                  icon: Icon(
                    Icons.warning,
                    color: Colors.amber,
                  ),
                ),
                new Tab(
                  text: "ENCONTRADOS",
                  icon: Icon(
                    Icons.done,
                    color: Colors.greenAccent[400],
                  ),
                )
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              //Primera Vista del Tab
              new FutureBuilder(
                  future: pgdata(this.id_almacen),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return Center(
                        child: new CircularProgressIndicator(),
                      );
                    }

                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext contex, int index) {
                        return Card(
                          elevation: 8.0,
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(64, 75, 96, .9),
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                leading: Container(
                                  padding: EdgeInsets.only(right: 12.0),
                                  decoration: new BoxDecoration(
                                      border: new Border(
                                          right: new BorderSide(
                                              width: 1.0,
                                              color: Colors.white24))),
                                  child: Icon(
                                    Icons.tab_unselected,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                    snapshot.data[index].producto.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                subtitle: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.linear_scale,
                                      color: Colors.amber,
                                      size: 12.0,
                                    ),
                                    Text(
                                      snapshot.data[index].codigo
                                          .toString()
                                          .toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.white24,
                                          fontSize: 13.0),
                                    ),
                                  ],
                                ),
                                trailing: Icon(
                                  Icons.power_input,
                                  color: Colors.white,
                                  size: 30.0,
                                ),
                                onTap: () {
                                  _displayDialog(
                                      contex, snapshot.data[index].id_trazable);
                                },
                              )),
                        );
                      },
                    );
                  }),

              //Segunda Vista del Tab
              new FutureBuilder(
                  future: pgdatasuccess(this.id_almacen),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return Center(
                        child: new CircularProgressIndicator(),
                      );
                    }

                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext contex, int index) {
                        return Card(
                          elevation: 8.0,
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(64, 75, 96, .9),
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                leading: Container(
                                  padding: EdgeInsets.only(right: 12.0),
                                  decoration: new BoxDecoration(
                                      border: new Border(
                                          right: new BorderSide(
                                              width: 1.0,
                                              color: Colors.white24))),
                                  child: Icon(
                                    Icons.tab_unselected,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                    snapshot.data[index].producto.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                subtitle: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.linear_scale,
                                      color: Colors.amber,
                                      size: 12.0,
                                    ),
                                    Text(
                                      snapshot.data[index].codigo
                                          .toString()
                                          .toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.white24,
                                          fontSize: 13.0),
                                    ),
                                  ],
                                ),
                                trailing: InkWell(
                                  child: Icon(
                                    Icons.power_input,
                                    color: Colors.white,
                                    size: 30.0,
                                  ),
                                  onTap: (){
                                    _showbottomShett(context,snapshot.data[index].id_trazable);
                                  },
                                ),
                                onTap: () {
                                  _displayDialog(
                                      contex, snapshot.data[index].id_trazable);
                                },
                              )),
                        );
                      },
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  _displayDialog(BuildContext context, String id_trazable) async {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Consts.padding),
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      top: Consts.padding,
                      bottom: Consts.padding,
                      left: Consts.padding,
                      right: Consts.padding),
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(Consts.padding),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0,
                            offset: Offset(0.0, 10.0))
                      ]),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Nueva Observación",
                        style: TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "Observación",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0))),
                        onChanged: (String value) {
                          observacion_det = value;
                        },
                      ),
                      SizedBox(height: 16.0),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: FlatButton(
                          child: Text(
                            "Aceptar",
                            style: TextStyle(color: Colors.blueGrey[600]),
                          ),
                          onPressed: () {
                            _InsertObs(int.parse(id_trazable), observacion_det);

                            Navigator.of(context).pop();
                            // Scaffold.of(context).showSnackBar(SnackBar(
                            //   content: Text("Agregado Correctamente"),
                            //   duration: Duration(seconds: 3),
                            // ));
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  _InsertObs(int id, String detalle) async {
    var connection = new PostgreSQLConnection("192.168.1.25", 5432, "posperu2",
        username: "postgres", password: "cildgbhiegbbile");
    await connection.open();
    //String sql="INSERT INTO observacion(id_trazable,detalle) values(@tr:int4,@det:varchar)";
    await connection.transaction((ct) async {
      await ct.query(
          "INSERT INTO observacion(id_trazable,detalle) values($id, '$detalle')");
    }).whenComplete(() {
      connection.close();
    });
  }

  _showbottomShett(BuildContext context, String id_trazable) {
    return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return FutureBuilder(
            future: _getobse(id_trazable),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: new CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: new Icon(
                      Icons.bubble_chart,
                      color: Colors.amber[800],
                    ),
                    title: Text(
                      snapshot.data[index].detalle.toString(),
                      style: TextStyle(
                          color: Colors.blueGrey[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                  );
                },
              );
            },
          );
        });
  }

  Future<List<MObservacion>> _getobse(String id_trazable) async {
    var connection = new PostgreSQLConnection(
      "192.168.1.25", 5432, "posperu2",
      username: "postgres", password: "cildgbhiegbbile");;
    await connection.open();
    String query =
        "select observacion.detalle from observacion where observacion.id_trazable='$id_trazable'";
    List<List<dynamic>> results = await connection
        .query(query)
        .catchError((onError) => print(onError))
        .whenComplete(() => connection.close());
    List<MObservacion> data = [];
    for (final row in results) {
      MObservacion ob = new MObservacion(row[0].toString());
      data.add(ob);
    }
    return data;
  }

  Future<List<Modeldata>> pgdata(String almacen) async {
    // var connection = new PostgreSQLConnection("190.117.72.58", 5434, "posperu2",
    //     username: "postgres", password: "Scimic?Developer?479");
    var connection = new PostgreSQLConnection("192.168.1.25", 5432, "posperu2",
        username: "postgres", password: "cildgbhiegbbile");
    await connection.open();
    String consulta = "SELECT " +
        "public.stk_producto.producto as producto, " +
        "public.stk_producto.codigo as codigo, " +
        "public.stk_trazable.id as id_trazable "
            "FROM " +
        "public.stk_almacen " +
        "INNER JOIN public.stk_trazable ON (public.stk_almacen.id = public.stk_trazable.almacen) " +
        "INNER JOIN public.stk_producto ON (public.stk_trazable.producto = public.stk_producto.id) " +
        "INNER JOIN public.stk_local ON (public.stk_almacen.local = public.stk_local.id) " +
        "INNER JOIN public.stk_marca ON (public.stk_producto.marca = public.stk_marca.id) " +
        "WHERE " +
        "stk_almacen.tipo = 1 and stk_almacen.id= '$almacen'";

    List<List<dynamic>> results = await connection
        .query(consulta)
        .catchError((d) => print(d))
        .whenComplete(() => connection.close());
    List<Modeldata> databd = [];
    //con.ce.clear();
    for (final row in results) {
      con.getCount(row[1].toString().toUpperCase()).then((onValue) {
        if (onValue != "ENCONTRADO") {
          Modeldata dat = Modeldata(
              row[0].toString(), row[1].toString(), row[2].toString());
          databd.add(dat);
        } else {
          print(row[1].toString());
        }
      });
    }
    return databd;
  }

  Future<List<Modeldata>> pgdatasuccess(String almacen) async {
    // var connection = new PostgreSQLConnection("190.117.72.58", 5434, "posperu2",
    //     username: "postgres", password: "Scimic?Developer?479");
    var connection = new PostgreSQLConnection("192.168.1.25", 5432, "posperu2",
        username: "postgres", password: "cildgbhiegbbile");
    await connection.open();
    String consulta = "SELECT " +
        "public.stk_producto.producto as producto, " +
        "public.stk_producto.codigo as codigo, " +
        "cast(public.stk_trazable.id as varchar) as id_trazable "
            "FROM " +
        "public.stk_almacen " +
        "INNER JOIN public.stk_trazable ON (public.stk_almacen.id = public.stk_trazable.almacen) " +
        "INNER JOIN public.stk_producto ON (public.stk_trazable.producto = public.stk_producto.id) " +
        "INNER JOIN public.stk_local ON (public.stk_almacen.local = public.stk_local.id) " +
        "INNER JOIN public.stk_marca ON (public.stk_producto.marca = public.stk_marca.id) " +
        "WHERE " +
        "stk_almacen.tipo = 1 and stk_almacen.id= '$almacen'";

    List<List<dynamic>> results = await connection
        .query(consulta)
        .catchError((d) => print(d))
        .whenComplete(() => connection.close());
    List<Modeldata> databd = [];
    //con.ce.clear();
    for (final row in results) {
      con.getCount(row[1].toString().toUpperCase()).then((onValue) {
        if (onValue == "ENCONTRADO") {
          Modeldata dat = Modeldata(
              row[0].toString(), row[1].toString(), row[2].toString());
          databd.add(dat);
        } else {
          print(row[1].toString());
        }
      });
    }
    return databd;
  }
}

class Modeldata {
  String producto;
  String codigo;
  String id_trazable;
  Modeldata(this.producto, this.codigo, this.id_trazable);
}

class Consts {
  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}

class MObservacion {
  String detalle;
  MObservacion(this.detalle);
}
