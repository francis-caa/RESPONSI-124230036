class Movie {
  final String id;
  final String title;
  final String description;
  final String image;
  final String releaseDate;
  final double rating;
  final List<String> genres;
  final Map<String, dynamic> raw;

  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.releaseDate,
    required this.rating,
    required this.genres,
    required this.raw,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
 
    String id = json['id']?.toString() ?? '';
    String title = json['title'] ?? json['name'] ?? 'No Title';
    String description = json['description'] ?? json['overview'] ?? '-';
    String image = json['image'] ?? json['poster'] ?? json['imageUrl'] ?? '';
    String releaseDate = json['release_date'] ?? json['released'] ?? '';
    double rating = 0.0;
    try {
      if (json['rating'] != null) rating = double.parse(json['rating'].toString());
      else if (json['vote_average'] != null) rating = double.parse(json['vote_average'].toString());
    } catch (e) {
      rating = 0.0;
    }
    List<String> genres = [];
    if (json['genre'] != null) {
      if (json['genre'] is String) {
        genres = (json['genre'] as String).split(',').map((s) => s.trim()).toList();
      } else if (json['genre'] is List) {
        genres = List<String>.from(json['genre'].map((g) => g.toString()));
      }
    } else if (json['genres'] != null) {
      if (json['genres'] is List) {
        genres = List<String>.from(json['genres'].map((g) => g.toString()));
      }
    }
    return Movie(
      id: id,
      title: title,
      description: description,
      image: image,
      releaseDate: releaseDate,
      rating: rating,
      genres: genres,
      raw: json,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'releaseDate': releaseDate,
      'rating': rating,
      'genres': genres.join(','),
      'raw': raw,
    };
  }
}

