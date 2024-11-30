import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Map<String, dynamic>? _movieData;
  String? _errorMessage;

  Future<void> _searchMovie() async {
    _searchFocusNode.unfocus(); // Cierra el teclado después de buscar
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _errorMessage = "Por favor ingresa un título.";
        _movieData = null;
      });
      return;
    }

    setState(() {
      _errorMessage = null;
      _movieData = null;
    });

    try {
      final url = Uri.parse(
          'https://www.omdbapi.com/?t=$query&apikey=84d25673'); // Asegúrate de usar la API Key correcta
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Response'] == 'True') {
          setState(() {
            _movieData = data;
          });
        } else {
          setState(() {
            _errorMessage = "No se encontraron resultados.";
          });
        }
      } else {
        setState(() {
          _errorMessage =
              "Error al conectarse con la API. Código: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Ocurrió un error: $e";
      });
    }
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _movieData = null;
      _errorMessage = null;
    });
    _searchFocusNode.requestFocus(); // Enfocar el campo de texto nuevamente
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Películas'),
        backgroundColor: const Color.fromARGB(255, 1, 9, 56),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/catalog');
          },
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed('/catalog'),
            child: const Text(
              'Catálogo',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed('/admin'),
            child: const Text(
              'Añadir/Editar',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed('/search'),
            child: const Text(
              'Buscar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/background-peliculas.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.6), BlendMode.darken),
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Busca una película por su título en inglés",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _searchController,
              focusNode: _searchFocusNode, // Asignar el FocusNode
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.green, // Cambiar color del cursor
              decoration: InputDecoration(
                hintText: "Título",
                hintStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.black54,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _searchMovie,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 30), // Tamaño del botón
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    "Buscar",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _clearSearch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 30), // Tamaño del botón
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    "Limpiar",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16,
                ),
              ),
            if (_movieData != null) _buildMovieDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          "Título: ${_movieData!['Title']}",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Año: ${_movieData!['Year']}",
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Director: ${_movieData!['Director']}",
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 10),
        if (_movieData!['Poster'] != 'N/A')
          Image.network(
            _movieData!['Poster'],
            height: 300,
            fit: BoxFit.contain,
          ),
      ],
    );
  }
}
