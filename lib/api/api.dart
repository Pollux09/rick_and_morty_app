import 'package:dio/dio.dart';

class APIUtil {
  final dio = Dio();
  final baseUrl = "https://rickandmortyapi.com/api";

  Future<List> getCharacters() async {
    final result = await dio.get("$baseUrl/character");
    final List charactersList = result.data["results"] as List;
    return charactersList;
  }
}

final apiUtil = APIUtil();
