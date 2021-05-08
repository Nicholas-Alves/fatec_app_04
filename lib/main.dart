import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = 'https://api.hgbrasil.com/finance';

void main() async {
  print(await pegarDados());
  runApp(
    MaterialApp(
      home: Home(),
    ),
  );
}

Future<Map> pegarDados() async {
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic> ibovespa;
  Map<String, dynamic> nasdaq;
  Map<String, dynamic> nikkei;
  Map<String, dynamic> cac;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Bolsas de Valores do Mundo"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: pegarDados(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Container(
                  width: 75,
                  height: 75,
                  child: CircularProgressIndicator(
                    semanticsLabel: "Carregando dados...",
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation(
                      Colors.blueAccent,
                    ),
                    strokeWidth: 5,
                  ),
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Erro ao carregar os dados",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                ibovespa = snapshot.data["results"]["stocks"]["IBOVESPA"];
                nasdaq = snapshot.data["results"]["stocks"]["NASDAQ"];
                nikkei = snapshot.data["results"]["stocks"]["NIKKEI"];
                cac = snapshot.data["results"]["stocks"]["CAC"];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        "images/bolsa.png",
                        fit: BoxFit.cover,
                        height: 100,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Column(
                          children: [
                            construirTexto(ibovespa["name"]),
                            construirTexto(ibovespa["location"]),
                            construirTexto(ibovespa["points"]),
                            construirTexto(ibovespa["variation"]),
                          ],
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Column(
                          children: [
                            construirTexto(nasdaq["name"]),
                            construirTexto(nasdaq["location"]),
                            construirTexto(nasdaq["points"]),
                            construirTexto(nasdaq["variation"]),
                          ],
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Column(
                          children: [
                            construirTexto(nikkei["name"]),
                            construirTexto(nikkei["location"]),
                            construirTexto(nikkei["variation"]),
                          ],
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Column(
                          children: [
                            construirTexto(cac["name"]),
                            construirTexto(cac["location"]),
                            construirTexto(cac["variation"]),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }

  Widget construirTexto(dynamic texto) {
    return Text(
      texto.toString(),
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.blueAccent,
        fontSize: 25,
      ),
    );
  }
}
