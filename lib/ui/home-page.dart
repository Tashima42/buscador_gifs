import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _search; //String que contem o valor da pesquisa

  int _offset = 0; // offset de quantos gifs serão mostrados na página de pesquisa

  Future<Map> _getGifs() async {
    http.Response response;

    if(_search == null)
      //API do Giphy mostrando os trendings, quando não há nenhuma pesquisa
      response = await http.get("https://api.giphy.com/v1/gifs/trending?api_key=c7el5t6AU6gd9Ap77AfnC63eAK2hXQmf&limit=20&rating=R");
    else
      //API do Giphy mostrando a pesquisa, com os valores dinamicos search e offset de quantos gifs irá mostrar
      response = await http.get("https://api.giphy.com/v1/gifs/search?api_key=c7el5t6AU6gd9Ap77AfnC63eAK2hXQmf&q=${_search}&limit=20&offset=${_offset}&rating=G&lang=en");
    //Transforma a string recebida no response http em um mapa json
    return json.decode(response.body);
  }

  @override
  void initState(){
    super.initState();

    _getGifs().then((map){
      print(map);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}