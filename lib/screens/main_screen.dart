import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/characters/characters_bloc.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CharactersBloc()..add(ButtonSubmit()),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: const Color.fromARGB(255, 20, 20, 20),
          appBar: AppBar(backgroundColor: Colors.lightBlueAccent),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, color: Colors.black),
                label: "Главная",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.abc, color: Colors.black),
                label: "Избранное",
              ),
            ],
            backgroundColor: Colors.lightBlueAccent,
            unselectedItemColor: Colors.black,
            fixedColor: Color.fromARGB(255, 0, 0, 0),
            currentIndex: 1,
          ),
          body: Center(
            child: BlocBuilder<CharactersBloc, CharactersState>(
              builder: (context, state) {
                return state.charactersList.isNotEmpty
                    ? ListView.builder(
                        padding: EdgeInsets.only(top: 18.0),
                        itemCount: state.charactersList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(top: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Image.network(
                                    state.charactersList[index]["image"],
                                    width: 96.0,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.charactersList[index]["name"],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : CircularProgressIndicator(color: Colors.black);
              },
            ),
          ),
        ),
      ),
    );
  }
}
