import 'package:dio/dio.dart';

class APIUtil {
  final dio = Dio();
  final baseUrl = "https://rickandmortyapi.com/api";

  Future<List?> getCharacters([int page = 1]) async {
    String url = "$baseUrl/character/?page=$page";
    if (page == 1) {
      url = "$baseUrl/character";
    }
    var result = await dio.get(url);
    final List charactersList = result.data["results"] as List;
    return charactersList;
  }
}

final apiUtil = APIUtil();
