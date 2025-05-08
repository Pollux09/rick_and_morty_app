import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/api/api.dart';
part 'characters_event.dart';
part 'characters_state.dart';

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  CharactersBloc() : super(CharactersState(charactersList: [])) {

    on<ButtonSubmit>((event, emit) async {
      // print("button submit event");
      List charactersList = await apiUtil.getCharacters();
      emit(CharactersState(charactersList: charactersList));
    });
  }
}