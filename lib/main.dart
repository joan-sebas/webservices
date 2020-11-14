import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:webservices/MODEL/soccer.dart';

import 'MODEL/posiciones.dart';
import 'MODEL/usuarios.dart';

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

class _HomePageState2 extends State<HomePage> {
  List<Usuarios> _usuario = List<Usuarios>();
  List<Usuarios> _mostrarUsuario = List<Usuarios>();

  Future<List<Usuarios>> fetchUsers() async {
    var url = 'https://jsonfy.com/users';
    var response = await http.get(url);

    var usuario = List<Usuarios>();

    if (response.statusCode == 200) {
      var usuarioJson = json.decode(response.body);
      for (var usuarioJson in usuarioJson) {
        usuario.add(Usuarios.fromJson(usuarioJson));
      }
    }
    return usuario;
  }

  @override
  void initState() {
    fetchUsers().then((value) {
      setState(() {
        _usuario.addAll(value);
        _mostrarUsuario = _usuario;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('WEBSERVICE LISTA DE USUARIOS'),
          backgroundColor: Colors.black,
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return index == 0 ? _busqueda() : _listaUsuarios(index - 1);
          },
          itemCount: _mostrarUsuario.length + 1,
        ));
  }

  _busqueda() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        decoration: InputDecoration(hintText: 'INGRESA EL NOMBRE A BUSCAR...'),
        onSubmitted: (texto) {
          texto = texto.toLowerCase();
          setState(() {
            _mostrarUsuario = _usuario.where((nombre) {
              var usuarioNombre = nombre.name.toLowerCase();
              return usuarioNombre.contains(texto);
            }).toList();
          });
        },
      ),
    );
  }

  _listaUsuarios(index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 24.0, bottom: 24.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              _mostrarUsuario[index].name,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _mostrarUsuario[index].email,
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
            Text(
              'Edad: ' + _mostrarUsuario[index].age,
              style: TextStyle(fontSize: 16, color: Colors.red[500]),
            ),
          ],
        ),
      ),
    );
  }
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
          title: Text('WEBSERVICE LISTA DE USUARIOS'),
          backgroundColor: Colors.black,
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return index == 0 ? _busqueda() : _listaUsuarios(index - 1);
          },
          itemCount: _teamsList.length + 1,
        ));
  }

  _busqueda() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        decoration: InputDecoration(hintText: 'INGRESA EL EQUIPO'),
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

  _listaUsuarios(index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 24.0, bottom: 24.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              _teamsList[index].strAlternate,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
