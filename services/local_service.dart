import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie_models.dart';

class LocalService {
  static const String keyFavorite = 'favorite movie';

  Future<List<Movie>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(keyFavorite) ?? [];
    return list.map((e) => Movie.fromJson(jsonDecode(e))).toList();
  }

  Future<void> saveFavorites(List<Movie> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final list = favorites.map((e) => jsonEncode(e.toMap())).toList();
    await prefs.setStringList(keyFavorite, list);
  }

  Future<void> toggleFavorite(Movie movie) async {
    final list = await getFavorites();
    final exists = list.any((a) => a.title == movie.title && a.description == movie.description);
    if (exists) {
      final newList = list.where((a) => !(a.title == movie.title && a.description == movie.description)).toList();
      await saveFavorites(newList);
    } else {
      list.add(movie);
      await saveFavorites(list);
    }
  }

  Future<bool> isFavorite(Movie movie) async {
    final list = await getFavorites();
    return list.any((a) => a.title == movie.title && a.description == movie.description);
  }
}
