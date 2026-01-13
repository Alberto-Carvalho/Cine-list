import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart'; // Importe a sua classe Movie aqu

class MovieService {
  final String _apiKey = '16cfe93a064c7bfac1763e5ce0afbb3d';
  final String _baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> getPopularMovies() async {
    final url = Uri.parse(
      '$_baseUrl/movie/popular?api_key=$_apiKey&language=pt-BR',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);

      final List<dynamic> results = body['results'];

      final List<Movie> movies = results.map((item) {
        return Movie.fromJson(item);
      }).toList();

      return movies;
    } else {
      throw Exception('Falha ao carregar filmes');
    }
  }
}
