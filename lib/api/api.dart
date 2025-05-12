import 'package:dio/dio.dart';

class APIUtil {
  final dio = Dio();
  final baseUrl = "https://rickandmortyapi.com/api";

  Future<List?> getCharacters([int page = 1]) async {
    final result = await dio.get("$baseUrl/character/?page=$page");
    final List charactersList = result.data["results"] as List;
    print(charactersList);
    return charactersList;
  }
}

final apiUtil = APIUtil();
