
/*
import 'package:flutter/material.dart';
import 'flutter_downloader.dart';


void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final url = new TextEditingController(
      text: 'https://flutter.io/images/flutter-mark-square-100.png');
  String status = '';

  @override
  initState() {
    super.initState();
  }

  download() {
    FlutterDownloader.download(url.text, 'flutter.pdf').then((result) {
      setState(() {
        status = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Example'),
        ),
        body: new Padding(
          padding: const EdgeInsets.all(16.0),
          child: new Column(
            children: <Widget>[
              new Text('Enter download url'),
              new TextFormField(controller: url),
              new SizedBox(height: 8.0),
              new RaisedButton(
                child: new Text('Download Now'),
                onPressed: () => download(),
              ),
              new Divider(),
              new Text(status)
            ],
          ),
        ),
      ),
    );
  }
}


*/
/*
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MaterialApp(
  home: MyApp(),
  debugShowCheckedModeBanner: false,
));

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  final pdfUrl = "http://sack.kerneltechnologiesgroup.com/kernelitservices/proyecto/downloadProyectosPdf/1/a/a/a/a";
  bool downloading = true;
  var progressString = "";

  @override
  void initState() {
    super.initState();

    downloadFile();
  }

  Future<void> downloadFile() async {
    Dio dio = Dio();

    try {
      var dir = await getApplicationDocumentsDirectory();

      await dio.download(pdfUrl, "${dir.path}/Reporte.pdf",
          onProgress: (rec, total) {
            print("Rec: $rec , Total: $total");

            setState(() {
              downloading = false;
              progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
            });
          });
    } catch (e) {
      print(e);
    }

    setState(() {
      downloading = false;
      progressString = "Completed";
    });
    print("Download completed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AppBar"),
      ),
      body: Center(
        child: downloading
            ? Container(
          height: 120.0,
          width: 200.0,
          child: Card(
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Downloading File: $progressString",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        )
            : Text("No Data"),
      ),
    );
  }
}

*/


import 'package:flutter/material.dart';

import 'dart:convert';
import 'flutter_picker.dart';
import 'PickerData.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/src/material/dialog.dart' as Dialog;
import 'package:http/http.dart' as http;
import 'dart:async';


void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final double listSpec = 4.0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String stateText;
  //////// Datos ocupados para json card y spinner
  List dataJSON;
  Future<String> getData() async{
    var response  = await http.get(
        Uri.encodeFull("http://sack.kerneltechnologiesgroup.com/kernelitservices/proyecto/obtenerDatosReporteProyectos/1/a/a/a/a"),headers:
    {
      "Accept": "application/json"
    }
    );
    this.setState((){
      dataJSON = json.decode(response.body)["List"];
    });
  }

  @override
  void initState() {
    //this.ambildate();
    this.getData();
  }

  String _mySelection;
  List<Map> _myJson = [
    {"id":0,"name":"INFONACOT"},
    {"id":1,"name":"KERNEL TECHNOLOGIES GROUP"},
    {"id":2,"name":"SEGOB"},
    {"id":3,"name":"PSD"}
  ];
  ///////


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Bienvenido usuario "recibir nombre"'),
        automaticallyImplyLeading: false,
        elevation: 0.0,
      ),
      //////////////
      body: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            // Vista de Boton para ingresr fecha inicio y feca fin de un proyecto
            Expanded(
              child: ListView(
                children: <Widget>[
                  (stateText != null) ? Text(stateText) : Container(),
                  SizedBox(height: listSpec),

                  RaisedButton(
                    child: Text(' Fecha Inicio y Fin de Proyecto'),
                    onPressed: () {
                      showPickerDateRange(context);
                    },
                  ),

                ],
              ),
            ),


            // spinner para listar CLientes
            Expanded(
              /////spinner
              child: new DropdownButton<String>(
                isDense: true,
                hint: new Text("Select"),
                value: _mySelection,
                onChanged: (String newValue) {
                  setState(() {
                    _mySelection = newValue;
                  });
                  print (_mySelection);
                },
                items: _myJson.map((Map map) {
                  return new DropdownMenuItem<String>(
                    value: map["id"].toString(),
                    child: new Text(
                      map["name"],
                    ),
                  );
                }).toList(),
              ),
            ),


            // creacion y llamado de card para almacenar los datos recibidos por el WS
            Expanded(
              child: new Card(
                color: new Color(0xFF333366),
                elevation: 9.0,
                child: new ListView.builder(
                  itemCount: dataJSON == null ? 0 : dataJSON.length,
                  itemBuilder: (context, i){
                    return
                      new Container(
                          color: new Color(0xFF333366),
                          padding: new EdgeInsets.all(10.0),
                          child:  new Card(
                              child:
                              new Container(
                                  padding: new EdgeInsets.all(20.0),
                                  child: new Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Text(
                                        "Nombre de cliente : "+ dataJSON[i]['cliente']['nombre'].toString(),
                                        style: new TextStyle(fontSize:20.0, color: Colors.blue),
                                      ),
                                      new Text("Proyecto: "+dataJSON[i]['nombre'].toString()),
                                      new Text("Fecha de inicio: "+dataJSON[i]['fecha_inicio'].toString()),
                                      new Text("Fecha de fin: "+dataJSON[i]['fecha_fin'].toString()),
                                      new Text("Horas estimadas: " + "0000"/*+dataJSON[i]['fecha_termino'].toString()*/),
                                      new Text("horas reales: "+dataJSON[i]['tiempo_total'].toString()),
                                    ],
                                  )
                              )
                          )
                      );
                  },
                ),
                //),
              ),
              //fin de mi card
            ),
          ]),
    );
  }

  showPicker(BuildContext context) {
    Picker picker = Picker(
        adapter: PickerDataAdapter<String>(pickerdata: JsonDecoder().convert(PickerData)),
        changeToFirst: true,
        textAlign: TextAlign.left,
        textStyle: const TextStyle(color: Colors.blue),
        columnPadding: const EdgeInsets.all(8.0),
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.getSelectedValues());
        }
    );
    picker.show(_scaffoldKey.currentState);
  }

  showPickerModal(BuildContext context) {
    Picker(
        adapter: PickerDataAdapter<String>(pickerdata: JsonDecoder().convert(PickerData)),
        changeToFirst: true,
        hideHeader: false,
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.adapter.text);
        }
    ).showModal(this.context); //_scaffoldKey.currentState);
  }

  showPickerIcons(BuildContext context) {
    Picker(
      adapter: PickerDataAdapter(data: [
        PickerItem(text: Icon(Icons.add), value: Icons.add, children: [
          PickerItem(text: Icon(Icons.more)),
          PickerItem(text: Icon(Icons.aspect_ratio)),
          PickerItem(text: Icon(Icons.android)),
          PickerItem(text: Icon(Icons.menu)),
        ]),
        PickerItem(text: Icon(Icons.title), value: Icons.title, children: [
          PickerItem(text: Icon(Icons.more_vert)),
          PickerItem(text: Icon(Icons.ac_unit)),
          PickerItem(text: Icon(Icons.access_alarm)),
          PickerItem(text: Icon(Icons.account_balance)),
        ]),
        PickerItem(text: Icon(Icons.face), value: Icons.face, children: [
          PickerItem(text: Icon(Icons.add_circle_outline)),
          PickerItem(text: Icon(Icons.add_a_photo)),
          PickerItem(text: Icon(Icons.access_time)),
          PickerItem(text: Icon(Icons.adjust)),
        ]),
        PickerItem(text: Icon(Icons.linear_scale), value: Icons.linear_scale, children: [
          PickerItem(text: Icon(Icons.assistant_photo)),
          PickerItem(text: Icon(Icons.account_balance)),
          PickerItem(text: Icon(Icons.airline_seat_legroom_extra)),
          PickerItem(text: Icon(Icons.airport_shuttle)),
          PickerItem(text: Icon(Icons.settings_bluetooth)),
        ]),
        PickerItem(text: Icon(Icons.close), value: Icons.close),
      ]),
      title: Text("Select Icon"),
      onConfirm: (Picker picker, List value) {
        print(value.toString());
        print(picker.getSelectedValues());
      },
    ).show(_scaffoldKey.currentState);
  }

  showPickerDateRange(BuildContext context) {
    print("canceltext: ${PickerLocalizations.of(context).cancelText}");

    Picker ps = new Picker(
        hideHeader: true,
        adapter: new DateTimePickerAdapter(type: PickerDateTimeType.kYMD, isNumberMonth: true),
        onConfirm: (Picker picker, List value) {
          print((picker.adapter as DateTimePickerAdapter).value);
        }
    );

    Picker pe = new Picker(
        hideHeader: true,
        adapter: new DateTimePickerAdapter(type: PickerDateTimeType.kYMD),
        onConfirm: (Picker picker, List value) {
          print((picker.adapter as DateTimePickerAdapter).value);
        }
    );

    List<Widget> actions = [
      FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: new Text(PickerLocalizations.of(context).cancelText)),
      FlatButton(
          onPressed: () {
            Navigator.pop(context);
            ps.onConfirm(ps, ps.selecteds);
            pe.onConfirm(pe, pe.selecteds);
          },
          child: new Text(PickerLocalizations.of(context).confirmText))
    ];

    Dialog.showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text("Duracion de Proyecto "),
            actions: actions,
            content: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Inicio de proyecto:"),
                  ps.makePicker(),
                  Text("Fin de proyecto:"),
                  pe.makePicker()
                ],
              ),
            ),
          );
        });
  }
}
