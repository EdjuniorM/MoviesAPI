import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie2/page/favorite_page.dart';
import 'package:movie2/page/movie_page.dart';
import '../db/db_provider.dart';
import '../models/movie_model.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scrollController = ScrollController();
  List<MovieModel> _movies = <MovieModel>[];
  bool isFav = false;
  int? _selectedIndex;
  List<MovieModel> favoriteDataList = <MovieModel>[];
  int page = 1;
  TextEditingController searchTextController = TextEditingController();
  bool isLoading = false;
  DbProvider favDB = DbProvider();

  @override
  void initState() {
    super.initState();
    _fetchAllMovies();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        _fetchAllMovies();
      }
    });
  }

  Future<List<MovieModel>> _fetchAllMovies() async {
    String url = "http://www.omdbapi.com/?s=star+wars&page=$page&apikey=2a6269df";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      List list = result["Search"];

      setState(() {
        page += 1;
        _movies
            .addAll(list.map((movie) => MovieModel.fromJson(movie)).toList());
      });
      return _movies;
    } else {
      throw Exception("Falha ao carregar!");
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _onSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text("Filmes e Series"),
              backgroundColor: Colors.black,
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.article_rounded)),
                  Tab(icon: Icon(Icons.favorite)),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                MoviesPage(),
                FavoritePage(),
              ],
            )));
  }
}