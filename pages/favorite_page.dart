import 'package:flutter/material.dart';
import '../models/movie_models.dart';
import '../services/local_service.dart';
import 'detail_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final local = LocalService();
  List<Movie> list = [];

  Future<void> load() async {
    list = await local.getFavorites();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    load();
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite movie"),
        centerTitle: true, 
      ),
      body: list.isEmpty
          ? const Center(child: Text("Belum ada favorit"))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: list.length,
              itemBuilder: (c, i) {
                final a = list[i];
                return Dismissible(
                  key: Key(a.title + a.description),
                  background: Container(color: Colors.red),
                  onDismissed: (_) async {
                    await local.toggleFavorite(a); 
                    await load();                  
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${a.title} dihapus")));
                  },
                  child: Card(
                    child: ListTile(
                      leading: Image.network(a.image),
                      title: Text(a.title),
                      subtitle: Text(a.description),
                      onTap: () async {
                        await Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(movie: a)));
                        await load();  
                      },
                    ),
                  ),
                );
              }),
    );
  }
}
