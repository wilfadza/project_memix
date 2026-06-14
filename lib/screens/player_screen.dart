import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/song_controller.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SongController>(
      builder: (context, controller, _) {
        final song = controller.currentSong;
        if (song == null) {
          return const Scaffold(
            backgroundColor: Color(0xFF0D0D15),
            body: Center(child: Text("Tidak ada lagu yang diputar", style: TextStyle(color: Colors.white54))),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFF0D0D15),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tombol close
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(height: 20),

                // Gambar placeholder album
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.music_note, size: 80, color: Colors.orange),
                ),
                const SizedBox(height: 30),

                // Judul lagu
                Text(
                  song.title,
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  song.artist,
                  style: const TextStyle(color: Colors.white54, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Tombol favorite
                IconButton(
                  icon: Icon(
                    controller.isFavorite(song) ? Icons.favorite : Icons.favorite_border,
                    color: controller.isFavorite(song) ? Colors.redAccent : Colors.white70,
                    size: 30,
                  ),
                  onPressed: () => controller.toggleFavorite(song),
                ),
                const SizedBox(height: 20),

                // Slider durasi
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Slider(
                        value: controller.duration.inSeconds > 0
                            ? controller.position.inSeconds.toDouble()
                            : 0,
                        max: controller.duration.inSeconds > 0
                            ? controller.duration.inSeconds.toDouble()
                            : 1,
                        activeColor: Colors.orange,
                        inactiveColor: Colors.white24,
                        onChanged: (value) {
                          controller.seek(Duration(seconds: value.toInt()));
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_formatDuration(controller.position), style: const TextStyle(color: Colors.white54, fontSize: 12)),
                            Text(_formatDuration(controller.duration), style: const TextStyle(color: Colors.white54, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Tombol kontrol
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => controller.playPrevious(),
                      icon: const Icon(Icons.skip_previous, color: Colors.white, size: 40),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: () => controller.togglePlayPause(),
                      icon: Icon(
                        controller.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                        color: Colors.orange,
                        size: 60,
                      ),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: () => controller.playNext(),
                      icon: const Icon(Icons.skip_next, color: Colors.white, size: 40),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}