import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/characters/characters_bloc.dart';

class CharacterItem extends StatelessWidget {
  final String characterName;
  final Uint8List characterImage;
  final String gender;
  final bool isFavorite;
  final dynamic characterKey;

  const CharacterItem({
    super.key,
    required this.characterName,
    required this.characterImage,
    required this.gender,
    required this.isFavorite,
    required this.characterKey,
  });

  @override
  Widget build(BuildContext context) {
    IconData genderIcon;
    Color genderColor;

    if (gender == "Male") {
      genderIcon = Icons.male;
      genderColor = Colors.blueAccent;
    } else if (gender == "Female") {
      genderIcon = Icons.female;
      genderColor = Colors.pinkAccent;
    } else {
      genderIcon = Icons.help_outline;
      genderColor = Colors.white;
    }

    return Card(
      color: const Color.fromARGB(255, 30, 30, 30),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.memory(
                    characterImage,
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 56.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          characterName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 8.0),
                        Icon(genderIcon, color: genderColor),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: Colors.amberAccent,
                size: 36,
              ),
              onPressed: () {
                final bloc = context.read<CharactersBloc>();
                if (isFavorite) {
                  bloc.add(
                    DeleteFavoriteCharacter(characterName: characterName),
                  );
                } else {
                  bloc.add(ToFavorite(characterName));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}