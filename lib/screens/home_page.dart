import 'package:cine_list/models/movie.dart';
import 'package:cine_list/services/movie_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Movie>> _futureMovies;

  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _futureMovies = MovieService().getPopularMovies();

    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshMoveis() async {
    setState(() {
      _futureMovies = MovieService().getPopularMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Cinema Explorer'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      backgroundColor: Colors.black87,

      body: Column(
        children: [
          TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintStyle: const TextStyle(color: Colors.white54),
              hintText: 'Pesquisar filmes...',
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.search, color: Colors.white),
              suffixIcon: _searchText.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null,
            ),
          ),

          Expanded(
            child: FutureBuilder<List<Movie>>(
              future: _futureMovies,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Erro: ${snapshot.error}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }

                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final AllMovies = snapshot.data!;

                  final filteredMovies = AllMovies.where((movie) {
                    final movieTitle = movie.title.toLowerCase();
                    final searchLower = _searchText.toLowerCase();
                    return movieTitle.contains(searchLower);
                  }).toList();

                  if (filteredMovies.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nenhum filme encontrado com esse nome.',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: _refreshMoveis,
                    color: Colors.deepPurple,
                    child: GridView.builder(
                      padding: EdgeInsets.all(10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                      itemCount: filteredMovies.length,
                      itemBuilder: (context, index) {
                        final movie = filteredMovies[index];
                        return _buildMovieCard(movie);
                      },
                    ),
                  );
                }

                return const Center(
                  child: Text(
                    'Nenhum filme encontrado',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildMovieCard(Movie movie) {
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    clipBehavior: Clip.antiAlias,
    child: Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          movie.fullPosterUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
        ),

        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Container(
            color: Colors.black.withOpacity(0.7),
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Text(
                  movie.title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '⭐ ${movie.voteAverage}',
                  style: const TextStyle(color: Colors.amber, fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
