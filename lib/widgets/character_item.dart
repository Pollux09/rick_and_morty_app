import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/characters/characters_bloc.dart';

class CharacterItem extends StatelessWidget {
  final String characterName;
  final Uint8List characterImage;
  final bool isFavorite;
  final dynamic characterKey;

  const CharacterItem({
    super.key,
    required this.characterName,
    required this.characterImage,
    required this.isFavorite,
    required this.characterKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Image.memory(characterImage, width: 96.0),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                characterName,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              IconButton(
                icon: isFavorite
                    ? Icon(Icons.star, color: Colors.lightBlueAccent)
                    : Icon(Icons.star_border, color: Colors.lightBlueAccent),
                onPressed: () {
                  if (!isFavorite) {
                    context.read<CharactersBloc>().add(
                      ToFavorite(characterKey),
                    );
                  } else {
                    context.read<CharactersBloc>().add(
                      DeleteFavoriteCharacter(characterKey: characterKey),
                    );
                  }
                },
                iconSize: 42.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
