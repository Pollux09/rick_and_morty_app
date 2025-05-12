part of 'characters_bloc.dart';

abstract class CharactersEvent {}

class LoadCharacters extends CharactersEvent {}

class LoadFavoriteCharacters extends CharactersEvent {}

class ToFavorite extends CharactersEvent {
  final dynamic characterKey;
  ToFavorite(this.characterKey);
}

class DeleteFavoriteCharacter extends CharactersEvent {
  final int characterKey;
  
  DeleteFavoriteCharacter({required this.characterKey});
}

class LoadNextPage extends CharactersEvent {
  final int page;

  LoadNextPage({required this.page});
}