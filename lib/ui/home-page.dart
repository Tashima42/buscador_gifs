import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search; //String que contem o valor da pesquisa

  int _offset =
      0; // offset de quantos gifs serão mostrados na página de pesquisa

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == null)
      //API do Giphy mostrando os trendings, quando não há nenhuma pesquisa
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=c7el5t6AU6gd9Ap77AfnC63eAK2hXQmf&limit=20&rating=R");
    else
      //API do Giphy mostrando a pesquisa, com os valores dinamicos search e offset de quantos gifs irá mostrar
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=c7el5t6AU6gd9Ap77AfnC63eAK2hXQmf&q=${_search}&limit=19&offset=${_offset}&rating=G&lang=en");
    //Transforma a string recebida no response http em um mapa json
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    _getGifs().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.network(
            "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Pesquise aqui",
                labelStyle: TextStyle(color: Colors.white, fontSize: 18.0),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              onSubmitted: (texto) {
                setState(() {
                  _search = texto;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: _getGifs(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                          width: 200.0,
                          height: 200.0,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 5.0,
                          ));
                    default:
                      if (snapshot.hasError)
                        return Container(color: Colors.red);
                      else
                        return _createGifTable(context, snapshot);
                  }
                }),
          ),
        ],
      ),
    );
  }

  int _getCount(List data) {
    if (_search == null)
      return data.length;
    else
      return data.length + 1;
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: _getCount(snapshot.data["data"]),
        itemBuilder: (context, index) {
          if (_search == null || index < snapshot.data["data"].length) {
            return GestureDetector(
              child: Image.network(
                snapshot.data["data"][index]["images"]["fixed_height"]["url"],
                height: 300,
                fit: BoxFit.cover,
              ),
            );
          } else
            return _increaseOffset();
        });
  }
  Widget _increaseOffset(){
    return Container(
      child: GestureDetector(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.add, color: Colors.white, size: 70.0,),
            Text(
              "Carregar mais",
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
        ],),
        onTap: (){
          setState(() {
            _offset += 19;
          });
        },
      ),
    );
  }
}
