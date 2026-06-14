import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/song_controller.dart';

class FavoriteSongsScreen extends StatelessWidget {
  const FavoriteSongsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D15),
      appBar: AppBar(
        title: const Text("Lagu Favorit", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<SongController>(
        builder: (context, controller, child) {
          if (controller.favoriteSongs.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada lagu favorit",
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: controller.favoriteSongs.length,
            itemBuilder: (context, i) {
              final song = controller.favoriteSongs[i];
              return Card(
                color: const Color(0xFF1C1C29),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 2,
                child: ListTile(
                  title: Text(song.title, style: const TextStyle(color: Colors.white)),
                  subtitle: Text(song.artist, style: const TextStyle(color: Colors.white54)),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.redAccent),
                    onPressed: () => controller.toggleFavorite(song),
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