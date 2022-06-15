import 'package:filmler_uygulamasi/Kategoriler.dart';
import 'package:filmler_uygulamasi/Screens/DetaySayfa.dart';
import 'package:filmler_uygulamasi/Screens/FilmlerSayfa.dart';
import 'package:filmler_uygulamasi/Screens/Profil.dart';
import 'package:filmler_uygulamasi/Screens/anasayfa.dart';
import 'package:filmler_uygulamasi/Screens/favourite_movies.dart';
import 'package:filmler_uygulamasi/Screens/login_page.dart';
import 'package:filmler_uygulamasi/Screens/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Filmler.dart';
import '../main.dart';

class RouterPage {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (_) => const MyApp());
      case '/loginPage':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/categories':
        var user = settings.arguments as User;
        return MaterialPageRoute(
            builder: (_) => Anasayfa(
                  user: user,
                ));
      case '/registerPage':
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case '/profilePage':
        return MaterialPageRoute(builder: (_) => const Profil());
      case '/moviesPage':
        var data = settings.arguments as Kategoriler;
        return MaterialPageRoute(builder: (_) => FilmlerSayfa(kategori: data));
      case '/moviesDetailPage':
        var data = settings.arguments as Filmler;
        return MaterialPageRoute(builder: (_) => DetaySayfa(film: data));
      case '/favouriteMovies':
        return MaterialPageRoute(builder: (_) => FavoriFilmler());

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
