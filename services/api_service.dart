import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_models.dart';

class ApiService {
  final String baseUrl = 'https://681388b3129f6313e2119693.mockapi.io/api/v1/movie';

  Future<List<Movie>> fetchMovies() async {
    final uri = Uri.parse(baseUrl);
    final resp = await http.get(uri);
    if (resp.statusCode == 200) {
      final List<dynamic> data = json.decode(resp.body);
      return data.map((e) => Movie.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load movies: ${resp.statusCode}');
    }
  }

  Future<Movie> fetchMovieDetail(String id) async {
    final uri = Uri.parse('$baseUrl/$id');
    final resp = await http.get(uri);
    if (resp.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(resp.body);
      return Movie.fromJson(data);
    } else {
      throw Exception('Failed to load movie detail: ${resp.statusCode}');
    }
  }
}
