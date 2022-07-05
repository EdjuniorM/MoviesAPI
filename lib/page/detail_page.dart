import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movie2/models/detail_model.dart';
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  final String model;
  DetailPage({Key? key, required this.model}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  detailModel? movieDetail;
  bool isLoading = false;

  @override
  void initState() {
    isLoading = true;
    // TODO: implement initState
    fetchDetail();
    super.initState();
  }

  fetchDetail() async {
    String url =
        "https://www.omdbapi.com/?t=" + widget.model + "&apikey=2a6269df";
    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      setState(() {
        movieDetail = detailModel.fromJson(json.decode(res.body.toString()));
        isLoading = false;
      });
      return movieDetail;
    } else {
      throw Exception("Falha em carregar!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Detalhes"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  SizedBox(
                      width: 150,
                      child: ClipRRect(
                        child: movieDetail!.poster == "N/A"
                            ? Text("Poster Não Carregado")
                            : Image.network(
                                movieDetail!.poster,
                              ),
                        borderRadius: BorderRadius.circular(10),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    movieDetail!.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    movieDetail!.plot,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
    );
  }
}