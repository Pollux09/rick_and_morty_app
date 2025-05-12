import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/characters/characters_bloc.dart';
import 'package:rick_and_morty_app/hive/hive_service.dart';
import 'package:rick_and_morty_app/widgets/character_item.dart';
import 'package:rick_and_morty_app/widgets/navigation_bar.dart';

class FavoritesScreen extends StatelessWidget {
  final HiveService hiveService;

  const FavoritesScreen({super.key, required this.hiveService});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CharactersBloc()..add(LoadFavoriteCharacters()),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightBlueAccent,
            title: Text("Персонажи", style: TextStyle(color: Colors.black)),
            automaticallyImplyLeading: false,
          ),
          backgroundColor: const Color.fromARGB(255, 20, 20, 20),
          body: Center(
            child: BlocBuilder<CharactersBloc, AppState>(
              builder: (context, state) {
                if (state is LoadedFavoriteCharactersState) {
                  if (state.favoriteCharacters.isEmpty) {
                    return Center(
                      child: Text(
                        "Пока пусто",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.only(top: 18.0),
                    itemCount: state.favoriteCharacters.length,
                    itemBuilder: (context, index) {
                      return CharacterItem(
                        characterName:
                            state.favoriteCharacters[index].characterName,
                        characterImage:
                            state.favoriteCharacters[index].characterImage,
                        gender: state.favoriteCharacters[index].gender,
                        isFavorite: state.favoriteCharacters[index].isFavorite,
                        characterKey: state.favoriteCharacters[index].key,
                      );
                    },
                  );
                } else {
                  return CircularProgressIndicator(color: Colors.white);
                }
              },
            ),
          ),
          bottomNavigationBar: NavigationBarWidget(currentIndex: 1),
        ),
      ),
    );
  }
}
