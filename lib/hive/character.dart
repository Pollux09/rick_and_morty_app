import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'character.g.dart';

@HiveType(typeId: 0)
class Character extends HiveObject {
  @HiveField(0)
  final String characterName;

  @HiveField(1)
  final Uint8List characterImage;

  @HiveField(2, defaultValue: false)
  bool isFavorite;

  Character(this.characterName, this.characterImage, {this.isFavorite = false});

  Character copyWith({
    String? characterName,
    Uint8List? characterImage,
    bool? isFavorite,
  }) {
    return Character(
      characterName ?? this.characterName,
      characterImage ?? this.characterImage,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}