import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'character.dart';

class HiveService {
  Box<Character> get box => Hive.box<Character>("characters");

  Future<void> removeBox() async {
    await box.clear();
  }

  Future<void> replaceCharacters(List<Character> newList) async {
    final box = Hive.box<Character>('characters');
    final existingKeys = box.keys.toSet();
    for (int i = 0; i < newList.length; i++) {
      final char = newList[i];
      if (i < existingKeys.length) {
        await box.put(i, char);
      } else {
        await box.add(char);
      }
    }
    // Удаление излишков, если newList меньше прежнего размера:
    for (final key in existingKeys.difference(Set.from(List.generate(newList.length, (i) => i)))) {
      await box.delete(key);
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

  Future<void> updateCharacter(int characterKey) async {
    final character = box.get(characterKey);
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
