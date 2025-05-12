import 'package:flutter/material.dart';

class NavigationBarWidget extends StatelessWidget {
  final int currentIndex;

  const NavigationBarWidget({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (value) =>  {
        if (value == 0) {
          Navigator.of(context).pushNamed("/"),
        } else if (value == 1) {
          Navigator.of(context).pushNamed("/favorites"),
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: Colors.black, size: 30,),
          label: "Главная",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite, color: Colors.black),
          label: "Избранное",
        ),
      ],
      backgroundColor: Colors.lightBlueAccent,
      unselectedItemColor: Colors.black,
      fixedColor: Color.fromARGB(255, 0, 0, 0),
      currentIndex: currentIndex,
    );
  }
}
