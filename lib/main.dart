import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:webservices/MODEL/soccer.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Teams> _teamsList = List<Teams>();
  Future<String> _loadProductAsset(String equipo) async {
    var url =
        'https://www.thesportsdb.com/api/v1/json/1/searchteams.php?t=$equipo';

    var response = await http.get(url);

    if (response.statusCode == 200) {
      return response.body;
    }
    return null;
  }
/*
Product _parseJsonForCrossword(String jsonString) {
  Map JSON = json.decode(jsonString);
  List<Image> words = new List<Image>();
  for (var word in JSON['across']) {
    words.add(new Image(word['number'], word['word']));
  }
  return new Product(JSON['id'], JSON['name'], new Image(words));
}
*/

  Future<Search> loadProduct(String equipo) async {
    String jsonProduct = await _loadProductAsset(equipo);
    final jsonResponse = json.decode(jsonProduct);
    Search product = new Search.fromJson(jsonResponse);
    var hola = product.teams[0].strTeam;
    print(hola);
    return product;
  }

  @override
  void initState() {
    loadProduct("Arsenal").then((value) {
      setState(() {
        _teamsList.addAll(value.teams);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('EQUIPOS DE FUTBOL'),
          backgroundColor: Colors.redAccent,
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return index == 0 ? _search() : _listaEquipos(index - 1);
          },
          itemCount: _teamsList.length + 1,
        ));
  }

  _search() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextField(
        decoration:
            InputDecoration(hintText: 'INGRESA EL EQUIPO (ejemplo: ARSENAL)'),
        onSubmitted: (texto) {
          texto = texto.toLowerCase();
          loadProduct(texto.toString()).then((value) {
            setState(() {
              _teamsList.clear();
              _teamsList.addAll(value.teams);
            });
          });
        },
      ),
    );
  }

  _listaEquipos(index) {
    if (_teamsList[index].strTeamLogo == null) {
      _teamsList[index].strTeamLogo =
          "https://cdn.shopify.com/s/files/1/0726/6249/products/No-Logo_b95bbc7f-d67b-4ab5-9ce2-bd5e15496bca.png?v=1515588320";
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 24.0, bottom: 40.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Nombre: ' + _teamsList[index].strTeam,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'APODO: ' + _teamsList[index].strAlternate,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'ESTADIO: ' + _teamsList[index].strStadium,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'LIGA: ' + _teamsList[index].strLeague,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Image.network(
              _teamsList[index].strTeamLogo,
              height: 80,
            )
          ],
        ),
      ),
    );
  }
}
