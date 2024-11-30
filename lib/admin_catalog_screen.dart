import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminCatalogScreen extends StatelessWidget {
  const AdminCatalogScreen({super.key});

  Future<void> _addOrEditMovie(BuildContext context,
      [DocumentSnapshot? movie]) async {
    final TextEditingController titleController =
        TextEditingController(text: movie?.get('title') ?? '');
    final TextEditingController yearController =
        TextEditingController(text: movie?.get('year') ?? '');
    final TextEditingController directorController =
        TextEditingController(text: movie?.get('director') ?? '');
    final TextEditingController genreController =
        TextEditingController(text: movie?.get('genre') ?? '');
    final TextEditingController synopsisController =
        TextEditingController(text: movie?.get('synopsis') ?? '');
    final TextEditingController imageUrlController =
        TextEditingController(text: movie?.get('imageUrl') ?? '');

    if (!context.mounted) return;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(movie == null ? 'Agregar Película' : 'Editar Película'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: yearController,
                decoration: const InputDecoration(labelText: 'Año'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: directorController,
                decoration: const InputDecoration(labelText: 'Director'),
              ),
              TextField(
                controller: genreController,
                decoration: const InputDecoration(labelText: 'Género'),
              ),
              TextField(
                controller: synopsisController,
                decoration: const InputDecoration(labelText: 'Sinopsis'),
                maxLines: 3,
              ),
              TextField(
                controller: imageUrlController,
                decoration:
                    const InputDecoration(labelText: 'URL de la imagen'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final data = {
                'title': titleController.text,
                'year': yearController.text,
                'director': directorController.text,
                'genre': genreController.text,
                'synopsis': synopsisController.text,
                'imageUrl': imageUrlController.text,
              };

              final firestore = FirebaseFirestore.instance;

              if (movie == null) {
                await firestore.collection('movies').add(data);
              } else {
                await firestore.collection('movies').doc(movie.id).update(data);
              }

              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteMovie(DocumentSnapshot movie) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('movies').doc(movie.id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administración del Catálogo'),
        backgroundColor: const Color.fromARGB(255, 1, 9, 56),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/catalog');
            },
            child: const Text(
              'Catálogo',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/admin');
            },
            child: const Text(
              'Añadir/Editar',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/search');
            },
            child: const Text(
              'Buscar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('movies').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No hay películas en el catálogo.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final movies = snapshot.data!.docs;

          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];

              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  leading: Image.network(
                    movie['imageUrl'],
                    fit: BoxFit.cover,
                    width: 50,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image);
                    },
                  ),
                  title: Text(movie['title']),
                  subtitle: Text('Director: ${movie['director']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _addOrEditMovie(context, movie),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteMovie(movie),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditMovie(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
