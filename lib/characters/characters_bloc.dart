import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/api/api.dart';
import 'package:rick_and_morty_app/hive/character.dart';
import 'package:rick_and_morty_app/hive/hive_service.dart';
part 'characters_event.dart';
part 'characters_state.dart';

class CharactersBloc extends Bloc<CharactersEvent, AppState> {
  CharactersBloc() : super(LoadingCharacters()) {
    on<ToFavorite>(_characterToFavorite);
    on<LoadCharacters>(_loadCharacters);
    on<LoadFavoriteCharacters>(_loadFavoriteCharacters);
    on<DeleteFavoriteCharacter>(_deleteFavoriteCharacter);
    on<LoadNextPage>(_loadNextPage);
  }

  // Загрузка персонажей при старте
  Future<void> _loadCharacters(event, emit) async {
    try {
      if (HiveService().boxIsEmptry()) {
        final newChars = await _fetchCharactersFromApi();
        await _saveCharactersToHive(newChars);

        emit(
          LoadedCharactersState(
            charactersList: HiveService().getAllCharacters(),
          ),
        );
      } else {
        final cached = HiveService().getAllCharacters();
        emit(LoadedCharactersState(charactersList: cached));
      }
    } catch (e) {
      final cached = HiveService().getAllCharacters();
      if (cached.isNotEmpty) {
        emit(LoadedCharactersState(charactersList: cached));
      } else {
        emit(LoadedErrorState());
      }
    }
  }

  // подгрузка новых персонажей
  Future<void> _loadNextPage(LoadNextPage event, Emitter<AppState> emit) async {
    try {
      if (state is LoadedCharactersState) {
        final currentState = state as LoadedCharactersState;
        final List<Character> currentCharacters = List.from(
          currentState.charactersList,
        );

        final List? apiData = await apiUtil.getCharacters(event.page);
        if (apiData is! List) throw Exception('Invalid API response');

        // Параллельная загрузка и обработка всех изображений
        final List<Character> newCharacters = await Future.wait(
          apiData.map<Future<Character>>((item) async {
            final Uint8List image = await downloadAndProcessImage(
              item["image"],
            );
            return Character(item["name"], image, item["gender"]);
          }),
        );

        currentCharacters.addAll(newCharacters);
        await HiveService().addNewCharacters(newCharacters);
        emit(LoadedCharactersState(charactersList: currentCharacters));
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

  Future<List<Character>> _fetchCharactersFromApi([int page = 1]) async {
    final List? apiData = await apiUtil.getCharacters(page);
    if (apiData is! List) throw Exception('Invalid API response');

    // Обработка всех картинок параллельно
    final List<Future<Character>> futures = apiData.map<Future<Character>>((
      item,
    ) async {
      final Uint8List image = await downloadAndProcessImage(item["image"]);
      return Character(item["name"], image, item["gender"]);
    }).toList();

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
    final dynamic characterName = event.characterName;

    await HiveService().updateCharacter(characterName);
    await _loadCharacters(event, emit);
  }

  // Удаление персонажа из избранных
  Future<void> _deleteFavoriteCharacter(
    DeleteFavoriteCharacter event,
    emit,
  ) async {
    final dynamic characterName = event.characterName;
    await HiveService().updateCharacter(characterName);
    // await _loadCharacters(event, emit);
    await _loadFavoriteCharacters(event, emit);
  }

  Future<Uint8List> downloadAndProcessImage(String url) async {
    final dio = Dio();
    final response = await dio.get<Uint8List>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    return response.data!;
  }
}
