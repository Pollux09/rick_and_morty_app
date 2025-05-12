part of 'characters_bloc.dart';


abstract class AppState {}

class LoadingCharacters extends AppState {}

class LoadedCharactersState extends AppState {
  LoadedCharactersState({required this.charactersList});

  final List<Character> charactersList;
}

class LoadedFavoriteCharactersState extends AppState {
  LoadedFavoriteCharactersState({required this.favoriteCharacters});

  final List<Character> favoriteCharacters;
}

class LoadingFavoriteCharactersState extends AppState {}

class LoadedErrorState extends AppState {}

