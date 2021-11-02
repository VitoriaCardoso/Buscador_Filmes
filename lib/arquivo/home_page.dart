import 'dart:convert';

import 'package:buscador_filme/arquivo/filme_detalhe.dart';
import 'package:buscador_filme/main.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import "dart:async";

import 'package:http/http.dart' as http;
import 'package:share/share.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _filmes = '';

  Future<Map> getFilmes() async {
    http.Response buscarfilme;

    if (_filmes == '') {
      buscarfilme = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/popular?api_key=647fb1deb189eaaa0ef4c3eae85dfeea')); //Mostra os filmes populares
    } else {
      buscarfilme = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/search/movie?api_key=647fb1deb189eaaa0ef4c3eae85dfeea&query=$_filmes'));
    }
    var detalhe = json.decode(buscarfilme.body);
    return detalhe;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.network(
            "https://www.themoviedb.org/assets/2/v4/logos/v2/blue_short-8e7b30f73a4020692ccca9c88bafe5dcb6f8a62a4c6bc55cd9ba82bb2cd95f6c.svg"),
        centerTitle: true,
        backgroundColor: Color(0xff002147),
      ),
      backgroundColor: Colors.black,
      body: Column(children: <Widget>[
        Divider(),
        Padding(
          padding: EdgeInsetsDirectional.all(10.0),
          child: TextField(
            decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 0.0),
                ),
                labelText: "Pesquise o filme",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(60))),
            style: TextStyle(
              color: Colors.white,
              fontSize: 25.0,
            ),
            textAlign: TextAlign.center,
            onSubmitted: (text) {
              setState(() {
                _filmes = text;
              });
            },
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: getFilmes(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Container(
                    width: 200.0,
                    height: 200.0,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 5.0,
                    ),
                  );
                case ConnectionState.none:
                  return Container(
                    width: 200.0,
                    height: 200.0,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 5.0,
                    ),
                  );
                default:
                  if (snapshot.hasError) {
                    return Text(
                      'Snapshot Erro!',
                      style: TextStyle(color: Colors.red),
                    );
                  } else {
                    return _tabelaFilmes(context, snapshot);
                  }
              }
            },
          ),
        )
      ]),
    );
  }
}

Widget _tabelaFilmes(BuildContext context, AsyncSnapshot snapshot) {
  return GridView.builder(
    padding: EdgeInsets.all(10.0),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 10.0,
      mainAxisSpacing: 10.0,
    ),
    itemCount: snapshot.data["results"].length,
    itemBuilder: (context, index) {
      var imageSnapshot = snapshot.data["results"][index]["poster_path"];
      return GestureDetector(
        child: Image.network(
          "https://image.tmdb.org/t/p/w500/$imageSnapshot",
          height: 400.0,
          width: 200.0,
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FilmesDestalhes(
                        snapshot.data["results"][index],
                        getFilmes: {},
                        idFilme: snapshot.data["results"][index]["id"],
                      )));
        },
        onLongPress: () {
          Share.share(
            snapshot.data["results"][index]["id"],
          );
        },
      );
    },
  );
}

 /*onTap:(){
          Navigator.push(context, MaterialPageRoute(builder: (context) => FilmesDestalhes(getFilmes: ,)));
        },*/
