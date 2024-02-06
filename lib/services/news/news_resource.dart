import 'package:dio/dio.dart';
import 'package:news/services/news/models.dart';

class NewsResource {
  Future<NewsResponse> getNewsResponse(String query) async {
    try {
      final response = await Dio().get(
          'https://newsapi.org/v2/everything?q=$query&apiKey=80d22e95b7054166b32252f99eb0cb45');
      print('-----------response from api-----------');
      print(response.data);
      return NewsResponse.fromJson(response.data);
    } catch (e) {
      return Future.error(e);
    }
  }
}
