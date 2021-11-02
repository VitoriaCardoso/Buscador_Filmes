import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import "dart:async";
import 'package:flutter_svg/flutter_svg.dart';

import 'package:http/http.dart' as http;

class FilmesDestalhes extends StatelessWidget {
  const FilmesDestalhes(
    data, {
    Key? key,
    required this.getFilmes,
    required this.idFilme,
  }) : super(key: key);

  final Object idFilme;
  final Map getFilmes;

  Future<Map> getDetails() async {
    http.Response request;
    request = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/$idFilme?api_key=647fb1deb189eaaa0ef4c3eae85dfeea'));
    var detalhe = json.decode(request.body);
    return detalhe;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(children: <Widget>[
        Divider(),
        Expanded(
          child: FutureBuilder(
            future: getDetails(),
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
                    return _detalhesFilmes(context, snapshot);
                  }
              }
            },
          ),
        )
      ]),
    );
  }
}

Widget _detalhesFilmes(BuildContext context, AsyncSnapshot snapshot) {
  return Scaffold(
      appBar: AppBar(
        title: SvgPicture.network(
            "https://www.themoviedb.org/assets/2/v4/logos/v2/blue_short-8e7b30f73a4020692ccca9c88bafe5dcb6f8a62a4c6bc55cd9ba82bb2cd95f6c.svg"),
        centerTitle: true,
        backgroundColor: Color(0xff002147),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share(
                  snapshot.data["poster_path"]);
            },
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: Row(
        children: <Widget>[
          Container(
              width: 200,
              height: 300,
              padding: EdgeInsets.all(10.0),
              child: Image.network("https://image.tmdb.org/t/p/w500/" +
                  snapshot.data["poster_path"].toString())),
          Expanded(
              child: Container(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            alignment: Alignment.topLeft,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(),
                  new Text(
                    snapshot.data["original_title"],
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Baskerville',
                        fontSize: 35.0),
                  ),
                  Divider(),
                  Divider(),
                  new Text(
                    'SINOPSE',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Baskerville',
                        fontSize: 20.0,
                        fontWeight: FontWeight.w100),
                  ),
                  Divider(),
                  new Text(
                    snapshot.data["overview"],
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Baskerville',
                      fontSize: 15.0,
                    ),
                  ),
                  Divider(),
                  new Text(
                    snapshot.data["release_date"] +
                        '  ' +
                        '• ' +
                        '  ' +
                        snapshot.data["genres"][0]["name"] +
                        '  • ' +
                        '  ' +
                        snapshot.data["original_language"],
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Baskerville',
                      fontSize: 15.0,
                    ),
                  ),
                  Divider(),
                ]),
          )),
        ],
      ));
}
