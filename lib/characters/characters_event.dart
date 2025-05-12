part of 'characters_bloc.dart';

abstract class CharactersEvent {}

class LoadCharacters extends CharactersEvent {}

class LoadFavoriteCharacters extends CharactersEvent {}

class ToFavorite extends CharactersEvent {
  final dynamic characterName;
  ToFavorite(this.characterName);
}

class DeleteFavoriteCharacter extends CharactersEvent {
  final dynamic characterName;
  
  DeleteFavoriteCharacter({required this.characterName});
}

class LoadNextPage extends CharactersEvent {
  final int page;

  LoadNextPage({required this.page});
}