import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'favorifilm_api.dart';

class FavoriFilmler extends StatefulWidget {
  FavoriFilmler({Key? key}) : super(key: key);

  @override
  State<FavoriFilmler> createState() => _FavoriFilmlerState();
}

class _FavoriFilmlerState extends State<FavoriFilmler> {
  late Future<FavouriteMoviesApi> movies;

  Future<FavouriteMoviesApi> fetchFavori() async {
    final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/Mertau/JSON/main/filmler.json'));

    if (response.statusCode == 200) {
      return FavouriteMoviesApi.fromJson(json.decode(response.body));
    } else {
      throw Exception('Yükleme Başarısız');
    }
  }

  @override
  void initState() {
    movies = fetchFavori();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Favori Filmer"),
      ),
      body: FutureBuilder<FavouriteMoviesApi>(
          future: movies,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 3.5,
                ),
                itemCount: snapshot.data!.movies!.length,
                itemBuilder: (context, indeks) {
                  return Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                              snapshot.data!.movies![indeks].imgUrl as String),
                        ),
                        Text(
                          snapshot.data!.movies![indeks].movieName as String,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
