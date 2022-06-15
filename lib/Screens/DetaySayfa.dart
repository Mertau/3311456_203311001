import 'package:filmler_uygulamasi/Filmler.dart';
import 'package:flutter/material.dart';

class DetaySayfa extends StatefulWidget {
  Filmler film;

  DetaySayfa({Key? key, required this.film}) : super(key: key);

  @override
  _DetaySayfaState createState() => _DetaySayfaState();
}

class _DetaySayfaState extends State<DetaySayfa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.film.film_ad),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.network(
                "http://kasimadalan.pe.hu/filmler/resimler/${widget.film.film_resim}"),
            Text(
              widget.film.film_yil.toString(),
              style: const TextStyle(fontSize: 30),
            ),
            Text(
              widget.film.yonetmen_ad,
              style: const TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}
