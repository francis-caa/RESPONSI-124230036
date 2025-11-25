import 'package:flutter/material.dart';
import '../models/movie_models.dart';
import '../services/api_service.dart';
import '../services/local_service.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final api = ApiService();
  final local = LocalService();
  late Future<List<Movie>> futureMovies;
  List<Movie> favorites = [];

  @override
  void initState() {
    super.initState();
    futureMovies = api.fetchMovies();
    _loadFav();
  }

  Future<void> _loadFav() async {
    favorites = await local.getFavorites();
    setState(() {});
  }

  bool _isFav(Movie a) => favorites.any((f) => f.title == a.title && f.description == a.description);

  void _toggleFav(Movie a) async {
    final bool before = _isFav(a); 

    await local.toggleFavorite(a);  
    await _loadFav();               

    final bool after = _isFav(a); 

    if (before != after && after == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${a.title} ditambahkan ke Favorit")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Movie List"), centerTitle: true),
      body: FutureBuilder<List<Movie>>(
        future: futureMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final list = snapshot.data ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final a = list[i];
              return Card(
                child: ListTile(
                  leading: Image.network(a.image, width: 50),
                  title: Text(a.title),
                  subtitle: Text(a.description), 
                  trailing: IconButton(
                    icon: Icon(
                      _isFav(a) ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: () => _toggleFav(a),
                  ),
                  onTap: () async {
                    await Navigator.push(context, 
                      MaterialPageRoute(builder: (_) => DetailPage(movie: a))
                    );
                    await _loadFav(); 
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
