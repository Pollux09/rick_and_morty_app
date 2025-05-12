import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'character.dart';

class HiveService {
  Box<Character> get box => Hive.box<Character>("characters");

  Future<void> removeBox() async {
    await box.clear();
  }

  Future<void> addNewCharacters(List<Character> newCharacters) async {
    for (var character in newCharacters) {
      await box.add(character);
    }
  }

  Future<void> addCharacter(Character character) async {
    await box.add(character);
  }

  List<Character> getAllCharacters() {
    var characters = box.values.toList();
    return characters;
  }

  Character? getCharacter(int key) {
    return box.get(key);
  }

  bool boxIsEmptry() {
    return box.isEmpty;
  }

  Future<void> updateCharacter(String characterName) async {
    final characterBox = box.values;

    // Ищем персонажа по имени
    final character = characterBox.firstWhere(
      (char) => char.characterName == characterName,
    );

    if (character != null) {
      character.isFavorite = !character.isFavorite;
      await character.save();
    }
  }

  List<Character> getFavoritesCharacters() {
    List<Character> favorites = [];

    List<Character> allCharacters = box.values.toList();
    for (Character character in allCharacters) {
      if (character.isFavorite == true) {
        favorites.add(character);
      }
    }
    return favorites;
  }

  Future<void> clearAllCharacters() async {
    await box.clear();
  }

  // Получение listenable для реактивных обновлений
  ValueListenable<Box<Character>> getCharactersListenable() {
    return box.listenable();
  }
}
