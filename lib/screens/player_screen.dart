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
            child: Stack(
              children: [
                // Background gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF1A1A2E),
                        const Color(0xFF0D0D15),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    // Header dengan tombol close
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 30),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Text(
                            "Now Playing",
                            style: TextStyle(color: Colors.white54, fontSize: 14, letterSpacing: 1),
                          ),
                          const SizedBox(width: 40),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Cover Art dengan efek glow - support asset cover
                    Hero(
                      tag: "album_art",
                      child: Container(
                        height: 280,
                        width: 280,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.3),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                          image: song.coverAssetPath != null
                              ? DecorationImage(
                            image: AssetImage(song.coverAssetPath!),
                            fit: BoxFit.cover,
                          )
                              : null,
                        ),
                        child: song.coverAssetPath == null
                            ? Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.orange.shade800, Colors.orange.shade400],
                            ),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: const Icon(Icons.music_note, size: 100, color: Colors.white),
                        )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Judul & Artist
                    Text(
                      song.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      song.artist,
                      style: const TextStyle(color: Colors.white54, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    // Favorit button with animation
                    GestureDetector(
                      onTap: () => controller.toggleFavorite(song),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: controller.isFavorite(song)
                              ? Colors.redAccent.withOpacity(0.2)
                              : Colors.transparent,
                        ),
                        child: Icon(
                          controller.isFavorite(song) ? Icons.favorite : Icons.favorite_border,
                          color: controller.isFavorite(song) ? Colors.redAccent : Colors.white70,
                          size: 32,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Slider durasi
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 4,
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                              activeTrackColor: Colors.orange,
                              inactiveTrackColor: Colors.white24,
                              thumbColor: Colors.orange,
                              overlayColor: Colors.orange.withOpacity(0.2),
                            ),
                            child: Slider(
                              value: controller.duration.inSeconds > 0
                                  ? controller.position.inSeconds.toDouble()
                                  : 0,
                              max: controller.duration.inSeconds > 0
                                  ? controller.duration.inSeconds.toDouble()
                                  : 1,
                              onChanged: (value) {
                                controller.seek(Duration(seconds: value.toInt()));
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(controller.position),
                                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                                ),
                                Text(
                                  _formatDuration(controller.duration),
                                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Tombol kontrol
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildControlButton(
                          icon: Icons.skip_previous,
                          size: 40,
                          onPressed: () => controller.playPrevious(),
                        ),
                        const SizedBox(width: 32),
                        _buildPlayPauseButton(controller),
                        const SizedBox(width: 32),
                        _buildControlButton(
                          icon: Icons.skip_next,
                          size: 40,
                          onPressed: () => controller.playNext(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildControlButton({required IconData icon, required double size, required VoidCallback onPressed}) {
    return IconButton(
      icon: Icon(icon, color: Colors.white, size: size),
      onPressed: onPressed,
      splashRadius: 30,
    );
  }

  Widget _buildPlayPauseButton(SongController controller) {
    return GestureDetector(
      onTap: () => controller.togglePlayPause(),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.orange.withOpacity(0.4), blurRadius: 12, spreadRadius: 2),
          ],
        ),
        child: Icon(
          controller.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
          color: Colors.orange,
          size: 70,
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}