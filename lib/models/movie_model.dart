import 'package:flutter/cupertino.dart';

class MovieModel with ChangeNotifier{
  final String imdbId;
  final String poster;
  final String title;
  final String year;

  MovieModel(
      {required this.imdbId,
      required this.title,
      required this.poster,
      required this.year});

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
        imdbId: json["imdbID"],
        poster: json["Poster"],
        title: json["Title"],
        year: json["Year"]);
  }

  Map<String,dynamic> toMap(){ 
    return <String,dynamic>{
      "id" : imdbId,
      "title" : title,
      "poster" : poster,
      "year" : year,
    };
  }
}