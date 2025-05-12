import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;
import 'package:rick_and_morty_app/api/api.dart';
import 'package:rick_and_morty_app/hive/character.dart';
import 'package:rick_and_morty_app/hive/hive_service.dart';
part 'characters_event.dart';
part 'characters_state.dart';

Uint8List _processImageInIsolate(Uint8List data) {
  final image = img.decodeImage(data)!;
  return Uint8List.fromList(img.encodeJpg(image, quality: 85));
}

class CharactersBloc extends Bloc<CharactersEvent, AppState> {
  CharactersBloc() : super(LoadingCharacters()) {
    on<ToFavorite>(_characterToFavorite);
    on<LoadCharacters>(_loadCharacters);
    on<LoadFavoriteCharacters>(_loadFavoriteCharacters);
    on<DeleteFavoriteCharacter>(_deleteFavoriteCharacter);
    on<LoadNextPage>(_loadNextPage);
  }

  Future<void> _loadNextPage(LoadNextPage event, Emitter<AppState> emit) async {
  try {
    // Получаем текущее состояние
    if (state is LoadedCharactersState) {
      final currentState = state as LoadedCharactersState;
      final List<Character> currentCharacters = List.from(currentState.charactersList);

      // Загружаем новые персонажи
      final List? apiData = await apiUtil.getCharacters(event.page);
      if (apiData is! List) throw Exception('Invalid API response');

      final List<Character> newCharacters = [];
      for (var item in apiData) {
        final Uint8List image = await downloadAndProcessImage(item["image"]);
        newCharacters.add(Character(item["name"], image));
      }

      // Объединяем списки
      currentCharacters.addAll(newCharacters);

      // Эмитим новое состояние
      emit(LoadedCharactersState(
        charactersList: currentCharacters,
      ));
    }
  } catch (e) {
    if (HiveService().boxIsEmptry()) {
      emit(LoadedErrorState());
    } else {
      final cached = HiveService().getAllCharacters();
      emit(LoadedCharactersState(charactersList: cached));
    }
  }
}

  // Загрузка избранных персонажей
  Future<void> _loadFavoriteCharacters(event, emit) async {
    final List<Character> favoriteCharacters = HiveService()
        .getFavoritesCharacters();
    emit(LoadedFavoriteCharactersState(favoriteCharacters: favoriteCharacters));
  }

  // Загрузка персонажей
  Future<void> _loadCharacters(event, emit) async {
    try {
      if (HiveService().boxIsEmptry()) {
        final newChars = await _fetchCharactersFromApi(event.page);
        await _saveCharactersToHive(newChars);
        emit(
          LoadedCharactersState(
            charactersList: HiveService().getAllCharacters(),
          ),
        );
      }
      final cached = HiveService().getAllCharacters();
      emit(LoadedCharactersState(charactersList: cached));
    } catch (e) {
      final cached = HiveService().getAllCharacters();
      if (cached.isNotEmpty) {
        emit(LoadedCharactersState(charactersList: cached));
      } else {
        emit(LoadedErrorState());
      }
    }
  }

  Future<List<Character>> _fetchCharactersFromApi([int page = 1]) async {
    final List? apiData = await apiUtil.getCharacters(page);
    if (apiData is! List) throw Exception('Invalid API response');

    // Обработка всех картинок параллельно
    final List<Future<Character>> futures = apiData.map<Future<Character>>((item) async {
      final Uint8List image = await downloadAndProcessImage(item["image"]);
      return Character(item["name"], image);
    }).toList();

    await _saveCharactersToHive(futures.cast<Character>());

    return await Future.wait(futures);
  }


  Future<void> _saveCharactersToHive(List<Character> characters) async {
    HiveService().replaceCharacters(characters);
  }

  // Добавление персонажа в избранные
  Future<void> _characterToFavorite(
    ToFavorite event,
    Emitter<AppState> emit,
  ) async {
    final dynamic characterKey = event.characterKey;

    await HiveService().updateCharacter(characterKey);
    await _loadCharacters(event, emit);
  }

  // Удаление персонажа из избранных
  Future<void> _deleteFavoriteCharacter(
    DeleteFavoriteCharacter event,
    emit,
  ) async {
    final characterKey = event.characterKey;
    await HiveService().updateCharacter(characterKey);
    await _loadCharacters(event, emit);
    await _loadFavoriteCharacters(event, emit);
  }

  Future<Uint8List> downloadAndProcessImage(String url) async {
    final dio = Dio();
    final response = await dio.get<Uint8List>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    return compute(_processImageInIsolate, response.data!);
  }
}
