import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:rick_and_morty_app/characters/characters_bloc.dart';
import 'package:rick_and_morty_app/hive/hive_service.dart';
import 'package:rick_and_morty_app/widgets/character_item.dart';
import 'package:rick_and_morty_app/widgets/navigation_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  final HiveService hiveService = HiveService();
  bool _isLoadingMore = false;

  void _loadMore() {
    if (!_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CharactersBloc()..add(LoadCharacters()),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: const Color.fromARGB(255, 20, 20, 20),
          appBar: AppBar(
            backgroundColor: Colors.lightBlueAccent,
            title: const Text(
              "Персонажи",
              style: TextStyle(color: Colors.black),
            ),
            automaticallyImplyLeading: false,
          ),
          bottomNavigationBar: NavigationBarWidget(currentIndex: 0),
          body: Center(
            child: BlocConsumer<CharactersBloc, AppState>(
              listener: (context, state) {
                if (state is LoadedCharactersState || state is LoadedErrorState) {
                  if (_isLoadingMore) {
                    setState(() {
                      _isLoadingMore = false;
                    });
                  }
                }
              },
              builder: (context, state) {
                if (state is LoadedCharactersState) {
                  return LazyLoadScrollView(
                    onEndOfPage: () {
                      context.read<CharactersBloc>().add(
                        LoadNextPage(
                          page: (state.charactersList.length / 20).round() + 1,
                        ),
                      );
                      _loadMore();
                    },
                    isLoading: _isLoadingMore,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 18.0),
                      itemCount:
                          state.charactersList.length + (_isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == state.charactersList.length &&
                            _isLoadingMore) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.0),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          );
                        }
                        return CharacterItem(
                          characterName:
                              state.charactersList[index].characterName,
                          characterImage:
                              state.charactersList[index].characterImage,
                          gender: state.charactersList[index].gender,
                          isFavorite: state.charactersList[index].isFavorite,
                          characterKey: state.charactersList[index].key,
                        );
                      },
                    ),
                  );
                } else if (state is LoadedErrorState) {
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.network_check, color: Colors.red),
                      Text(
                        'Check internet connection...',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  );
                } else {
                  return const CircularProgressIndicator(color: Colors.white);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}