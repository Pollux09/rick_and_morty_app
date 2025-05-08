import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/screens/favorite_screen.dart';
import 'package:rick_and_morty_app/screens/main_screen.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: "/",
    routes: {
      "/": (context) => const MainScreen(),
      "/favorites": (context) => const FavoritesScreen(),
    },
  ));
}
