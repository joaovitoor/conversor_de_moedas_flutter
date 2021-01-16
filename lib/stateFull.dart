import 'package:estudo_flutter/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:estudo_flutter/stateFull.dart';

const request="https://api.hgbrasil.com/finance?key=7d504e34";

Future<Map> getData()async{
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);



  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double dolar, euro;

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  void _realChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }

    double dolar = double.parse(text);
    realController.text = (dolar*this.dolar).toStringAsFixed(2);
    euroController.text = ((dolar*this.dolar)/euro).toStringAsFixed(2);
  }

  void _euroChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }

    realController.text = (euro*this.euro).toStringAsFixed(2);
    dolarController.text = ((euro*this.euro)/dolar).toStringAsFixed(2);

  }

  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";

  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(

        title: Text("Conversor"),
        centerTitle: true,
        actions: [IconButton(icon: Icon(Icons.monetization_on, size: 40, color: Colors.amberAccent,), onPressed: (){} )],
        leading: Switch(
          value: Controller.instance.isDartTheme,
          onChanged: (value){
            Controller.instance.changeTheme();
          },
        ),

      ),
      body: Center(
      child: SingleChildScrollView(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[

            ClipRRect(
              borderRadius: BorderRadius.circular(50),

              child: Container(


                decoration: BoxDecoration(

                  border: Border.all(
                    color: Colors.lime,
                    style: BorderStyle.solid,
                    width: 5,

                  ),


                ),

                child:  Image.asset(
                  'imagens/dolar_fundo.jpeg',

                  fit: BoxFit.cover
                ),


              ),
             



              ),
            Opacity(
                opacity: 0.2,
                child: Divider(

                thickness: 2,
                height: 100,
                indent: 45,
                endIndent: 45,
                color: Colors.green[200],

              ),
            ),
            FutureBuilder<Map>(
                future: getData(),
                builder: (context, snapshot){
                  switch (snapshot.connectionState){
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                        child: Text("Carregando Dados...",
                          style: TextStyle(
                              color: Colors.amberAccent, fontSize: 25
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    default:
                      if(snapshot.hasError){
                        return Center(
                          child: Text("Erro ao carregar Dados...",
                            style: TextStyle(
                                color: Colors.redAccent, fontSize: 25
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      } else{

                        dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                        print(dolar);

                        euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                        print(euro);

                        return SingleChildScrollView(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[

                              buildTextField("Real", "R\$", realController, _realChanged),
                              Divider(),
                              buildTextField("Dolar", "US\$", dolarController, _dolarChanged),
                              Divider(),
                              buildTextField("Euro", "€\$", euroController, _euroChanged),
                              
                            ],
                          ),
                        );

                      }


                  } // ta errado consertar olhando o do professor
            })
          ],
        ),
      ), //Coloquei mais um SingleChildScrollView porque estava dando erro na hora em que se abria o teclado
      ),
    );
  }
}

Widget buildTextField(String label, String prefix,
TextEditingController c, Function f){
  return TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amberAccent),
      border: OutlineInputBorder(),
      prefixText: prefix
    ),
    style: TextStyle(
      color: Colors.green, fontSize: 25.0
    ),
    onChanged: f,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}
