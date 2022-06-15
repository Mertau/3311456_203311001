import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Profil extends StatefulWidget {
  const Profil({Key? key}) : super(key: key);

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  var userEmail = FirebaseAuth.instance.currentUser!.email;
  List<Map<String, dynamic>> _userDetails = [];
  final profileData = Hive.box("loginAndUserData");
  var sonGiris = "VERİ BULUNMUYOR";
  void _bilgileriGuncelle() {
    if (profileData.isNotEmpty) {
      final data = profileData.keys.map((key) {
        final value = profileData.get(key);
        return {
          "key": key,
          "lastLogin": value["lastLogin"],
          "userEmail": value["userEmail"],
        };
      }).toList();
      setState(
        () {
          _userDetails = data.reversed.toList();
          sonGiris = _userDetails[0]["lastLogin"].toString();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _bilgileriGuncelle();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile Challenge 01',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Center(
            child: Text('Profil'),
          ),
          actions: [
            PopupMenuButton(itemBuilder: (context) {
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text("Anasayfa"),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: Text("Sign Out"),
                ),
              ];
            }, onSelected: (value) {
              if (value == 0) {
                print("Homepage menu is selected.");
                Navigator.pushNamed(context, "/categories",
                    arguments: FirebaseAuth.instance.currentUser);
              } else if (value == 1) {
                print("Sign Out is selected.");
                FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, "/loginPage");
              }
            }),
          ],
        ),
        body: ListView(
          children: <Widget>[
            Container(
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red, Colors.deepOrange.shade300],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: const [0.5, 0.9],
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.white70,
                          minRadius: 60.0,
                          child: CircleAvatar(
                            radius: 50.0,
                            backgroundImage: NetworkImage(
                                'https://avatars0.githubusercontent.com/u/28812093?s=460&u=06471c90e03cfd8ce2855d217d157c93060da490&v=4'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Son giriş bilgisi :  " + sonGiris,
                      style: const TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    FirebaseAuth.instance.currentUser!.email as String,
                    style: const TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    userEmail as String,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
