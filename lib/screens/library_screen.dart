import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/song_controller.dart';
import '../models/song_model.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D15),
      appBar: AppBar(
        title: const Text("Perpustakaan", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0D0D15),
        elevation: 0,
      ),
      body: Consumer<SongController>(
        builder: (context, controller, child) {
          final favoriteSongs = controller.favoriteSongs;
          if (favoriteSongs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.white30),
                  SizedBox(height: 16),
                  Text("Belum ada lagu favorit", style: TextStyle(color: Colors.white54)),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: favoriteSongs.length,
            itemBuilder: (context, index) {
              final song = favoriteSongs[index];
              return ListTile(
                leading: song.coverAssetPath != null
                    ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.asset(song.coverAssetPath!, width: 40, height: 40, fit: BoxFit.cover))
                    : const Icon(Icons.music_note, color: Colors.orange),
                title: Text(song.title, style: const TextStyle(color: Colors.white)),
                subtitle: Text(song.artist, style: const TextStyle(color: Colors.white54)),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: () => controller.toggleFavorite(song),
                ),
                onTap: () => controller.playSong(song),
              );
            },
          );
        },
      ),
    );
  }
}