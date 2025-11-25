import 'package:flutter/material.dart';
import '../models/movie_models.dart';
import '../services/local_service.dart';

class DetailPage extends StatefulWidget {
  final Movie movie;
  const DetailPage({super.key, required this.movie});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final local = LocalService();
  bool isFav = false;

  @override
  void initState() {
    super.initState();
    _checkFav();
  }

  Future<void> _checkFav() async {
    isFav = await local.isFavorite(widget.movie);
    setState(() {});
  }

  Future<void> _toggle() async {
    await local.toggleFavorite(widget.movie);
    await _checkFav();
  }

  Widget info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        SizedBox(width: 120, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
        const Text(": "),
        Expanded(child: Text(value)),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.movie;
    return Scaffold(
      appBar: AppBar(
        title: Text(a.title),
        actions: [
          IconButton(
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggle,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          Image.network(a.image, height: 200),
          const SizedBox(height: 16),
          info("Nama", a.title),
          info("Deskripsi", a.description),
          info("Image", a.image),
          info("Release Date", a.releaseDate),
          const Divider(),
          //info("rating", a.rating),
          //info("genre", a.genres),
          //info("raw", a.raw),
        ]),
      ),
    );
  }
}
