import 'package:filmler_uygulamasi/Kategoriler.dart';
import 'package:filmler_uygulamasi/authentication_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Anasayfa extends StatefulWidget {
  final User user;

  const Anasayfa({
    Key? key,
    required this.user,
  }) : super(key: key);
  @override
  _AnasayfaState createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  var refKategoriler = FirebaseDatabase.instance.ref().child("kategoriler");
  final _authClient = AuthenticationClient();

  bool _isProgress = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kategoriler"),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              const PopupMenuItem<int>(
                value: 0,
                child: Text("My Account"),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text("Sign Out"),
              ),
            ];
          }, onSelected: (value) {
            if (value == 0) {
              print("My account menu is selected.");
              Navigator.pushNamed(context, "/profilePage");
            } else if (value == 1) {
              print("Sign Out is selected.");
              FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, "/loginPage");
            }
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<DatabaseEvent>(
              stream: refKategoriler.onValue,
              builder: (context, event) {
                if (event.hasData) {
                  var kategoriListesi = <Kategoriler>[];

                  var gelenDegerler = event.data!.snapshot.value as dynamic;

                  if (gelenDegerler != null) {
                    gelenDegerler.forEach((key, nesne) {
                      var gelenKategori = Kategoriler.fromJson(key, nesne);
                      kategoriListesi.add(gelenKategori);
                    });
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: kategoriListesi.length,
                    itemBuilder: (context, indeks) {
                      var kategori = kategoriListesi[indeks];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/moviesPage",
                              arguments: kategoriListesi[indeks]);
                        },
                        child: Card(
                          child: SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(kategori.kategori_ad),
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
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/favouriteMovies");
              },
              child: Card(
                child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Center(child: Text("Favoriler")),
                ),
              ),
            ),
            SfCartesianChart(
                // Initialize category axis
                title: ChartTitle(text: "Aylara Göre Satış Getirisi"),
                primaryXAxis: CategoryAxis(),
                series: <LineSeries<SalesData, String>>[
                  LineSeries<SalesData, String>(
                      // Bind data source
                      dataSource: <SalesData>[
                        SalesData('Jan', 35),
                        SalesData('Feb', 28),
                        SalesData('Mar', 34),
                        SalesData('Apr', 32),
                        SalesData('May', 40)
                      ],
                      xValueMapper: (SalesData sales, _) => sales.year,
                      yValueMapper: (SalesData sales, _) => sales.sales)
                ]),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child:
                  Image(image: AssetImage("assets/images/kapak_103014.webp")),
            ),
          ],
        ),
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
