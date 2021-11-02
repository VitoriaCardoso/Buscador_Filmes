import 'dart:convert';

import 'package:buscador_filme/arquivo/home_page.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:async/async.dart';

import 'dart:async';

import 'dart:convert';

import 'arquivo/filme_detalhe.dart';

void main() async {
  runApp(MaterialApp(
    home: HomePage(),
    theme: ThemeData(
        fontFamily: 'Baskerville',
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        )),
  ));
}
