import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/song_controller.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D15),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Perpustakaan", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Consumer<SongController>(
        builder: (context, controller, child) {
          final favorites = controller.favoriteSongs;
          if (favorites.isEmpty) {
            return const Center(
              child: Text("Belum ada lagu favorit", style: TextStyle(color: Colors.white54)),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: favorites.length,
            itemBuilder: (context, i) {
              final song = favorites[i];
              return Card(
                color: const Color(0xFF1C1C29),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                child: ListTile(
                  leading: const Icon(Icons.favorite, color: Colors.redAccent),
                  title: Text(song.title, style: const TextStyle(color: Colors.white)),
                  subtitle: Text(song.artist, style: const TextStyle(color: Colors.white54)),
                  trailing: IconButton(
                    icon: const Icon(Icons.play_arrow, color: Colors.orange),
                    onPressed: () => controller.playSong(song),
                  ),
                  onTap: () => controller.playSong(song),
                ),
              );
            },
          );
        },
      ),
    );
  }
}