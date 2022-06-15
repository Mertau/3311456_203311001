import 'dart:io';

import 'package:filmler_uygulamasi/Filmler.dart';
import 'package:filmler_uygulamasi/Kategoriler.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

class FilmlerSayfa extends StatefulWidget {
  Kategoriler kategori;

  FilmlerSayfa({Key? key, required this.kategori}) : super(key: key);

  @override
  _FilmlerSayfaState createState() => _FilmlerSayfaState();
}

class _FilmlerSayfaState extends State<FilmlerSayfa> {
  var refFilmler = FirebaseDatabase.instance.ref().child("filmler");
  Future<String> get getDosyaYolu async {
    Directory dosya = await getApplicationDocumentsDirectory();
    return dosya.path;
  }

  Future get dosyaOlustur async {
    var dosyakonumu = await getDosyaYolu;
    return File(dosyakonumu + "/notdosyasi.txt");
  }

  Future dosyaYaz(String dosyaninIcerigi) async {
    var myDosya = await dosyaOlustur;

    return myDosya.writeAsString(dosyaninIcerigi);
  }

  Future<String> okunacakDosya() async {
    try {
      var myDosya = await dosyaOlustur;

      String dosyaicergi = myDosya.readAsStringSync();
      return dosyaicergi;
    } catch (exception) {
      debugPrint("HATA :$exception");
    }
    return okunacakDosya();
  }

  void Yaz(String deger) async {
    dosyaYaz(deger).then((value) {
      setState(() {
        Fluttertoast.showToast(msg: "Dosya Kaydedildi " + deger);
      });
    });
  }

  void Oku() async {
    okunacakDosya().then((String deger) {
      setState(() {
        Fluttertoast.showToast(msg: "Dosya Okunuyor " + deger);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filmler : ${widget.kategori.kategori_ad}"),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: refFilmler
            .orderByChild("kategori_ad")
            .equalTo(widget.kategori.kategori_ad)
            .onValue,
        builder: (context, event) {
          if (event.hasData) {
            var filmlerListesi = <Filmler>[];

            var gelenDegerler = event.data!.snapshot.value as dynamic;

            if (gelenDegerler != null) {
              gelenDegerler.forEach((key, nesne) {
                var gelenFilm = Filmler.fromJson(key, nesne);
                filmlerListesi.add(gelenFilm);
              });
            }
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3.5,
              ),
              itemCount: filmlerListesi.length,
              itemBuilder: (context, indeks) {
                var film = filmlerListesi[indeks];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/moviesDetailPage",
                        arguments: filmlerListesi[indeks]);
                  },
                  child: Card(
                    child: GestureDetector(
                      onDoubleTap: () {
                        Yaz(film.film_ad);
                      },
                      onLongPress: () {
                        Oku();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                                "http://kasimadalan.pe.hu/filmler/resimler/${film.film_resim}"),
                          ),
                          Text(
                            film.film_ad,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center();
          }
        },
      ),
    );
  }
}
