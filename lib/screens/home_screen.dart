import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/song_controller.dart';
import 'player_screen.dart';
import 'profile_screen.dart';
import 'library_screen.dart';
import 'search_screen.dart';
import '../models/song_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const LibraryScreen(),
    const SearchScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D15),
      body: Stack(
        children: [
          _pages[_selectedIndex],
          Consumer<SongController>(
            builder: (context, controller, child) {
              if (controller.currentSong == null) return const SizedBox.shrink();
              return Positioned(
                bottom: 60,
                left: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerScreen())),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2E).withOpacity(0.95),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(color: Colors.black45, blurRadius: 12, offset: const Offset(0, 4)),
                        BoxShadow(color: Colors.orange.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 0)),
                      ],
                      border: Border.all(color: Colors.white10, width: 0.5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Column(
                        children: [
                          LinearProgressIndicator(
                            value: controller.duration.inSeconds > 0
                                ? controller.position.inSeconds / controller.duration.inSeconds
                                : 0,
                            backgroundColor: Colors.white24,
                            color: Colors.orange,
                            minHeight: 3,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: controller.currentSong!.coverAssetPath != null
                                          ? DecorationImage(
                                        image: AssetImage(controller.currentSong!.coverAssetPath!),
                                        fit: BoxFit.cover,
                                      )
                                          : null,
                                    ),
                                    child: controller.currentSong!.coverAssetPath == null
                                        ? Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Colors.orange.shade700, Colors.orange.shade400],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(Icons.music_note, color: Colors.white, size: 24),
                                    )
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          controller.currentSong!.title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            shadows: [Shadow(blurRadius: 2, color: Colors.black26)],
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          controller.currentSong!.artist,
                                          style: const TextStyle(color: Colors.white54, fontSize: 11),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.white10,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      _formatDuration(controller.position),
                                      style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  _buildMiniButton(
                                    icon: controller.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                                    color: Colors.orange,
                                    size: 34,
                                    onPressed: () => controller.togglePlayPause(),
                                  ),
                                  _buildMiniButton(
                                    icon: Icons.skip_next,
                                    color: Colors.white70,
                                    size: 28,
                                    onPressed: () => controller.playNext(),
                                  ),
                                  _buildMiniButton(
                                    icon: Icons.close,
                                    color: Colors.white54,
                                    size: 22,
                                    onPressed: () => controller.stop(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0D0D15),
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.white54,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.library_music), label: "Perpustakaan"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Temukan"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  Widget _buildMiniButton({required IconData icon, required Color color, required double size, required VoidCallback onPressed}) {
    return IconButton(
      icon: Icon(icon, color: color, size: size),
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      splashRadius: 20,
    );
  }
}

// ================= HOME CONTENT YANG DIPERCANTIK =================
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Selamat Pagi";
    if (hour < 15) return "Selamat Siang";
    if (hour < 18) return "Selamat Sore";
    return "Selamat Malam";
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          floating: true,
          pinned: false,
          expandedHeight: 120,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1A1A2E),
                    Color(0xFF0D0D15),
                  ],
                ),
              ),
            ),
            title: const Text(
              "Memix",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 28,
                shadows: [Shadow(blurRadius: 8, color: Colors.black45)],
              ),
            ),
            centerTitle: false,
            titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white70),
              onPressed: () {},
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.withOpacity(0.1), Colors.transparent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${_getGreeting()}, Willyam!",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Temukan musik favoritmu hari ini",
                      style: TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ]),
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "✨ Rekomendasi Untukmu",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 220,
                child: Consumer<SongController>(
                  builder: (context, controller, child) {
                    final recSongs = controller.songs.take(3).toList();
                    if (recSongs.isEmpty) {
                      return const Center(child: Text("Tidak ada lagu", style: TextStyle(color: Colors.white54)));
                    }
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: recSongs.length,
                      itemBuilder: (context, index) => _buildModernCard(recSongs[index], controller, context),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const Text(
                "🔥 Trending Minggu Ini",
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -0.3),
              ),
              const SizedBox(height: 12),
            ]),
          ),
        ),
        Consumer<SongController>(
          builder: (context, controller, child) {
            final allSongs = controller.songs;
            List<Song> trendingSongs;
            if (allSongs.length >= 3) {
              trendingSongs = (allSongs.toList()..shuffle()).take(3).toList();
            } else {
              trendingSongs = allSongs;
            }
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildTrendingItem(trendingSongs[index], index + 1, controller),
                childCount: trendingSongs.length,
              ),
            );
          },
        ),
        SliverPadding(
          padding: const EdgeInsets.only(top: 16, left: 20, right: 20),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                const Icon(Icons.library_music, color: Colors.orange, size: 24),
                const SizedBox(width: 8),
                const Text(
                  "Semua Lagu",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -0.3),
                ),
                const SizedBox(width: 8),
                Consumer<SongController>(
                  builder: (context, controller, child) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${controller.songs.length} lagu",
                      style: const TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(top: 12)),
        Consumer<SongController>(
          builder: (context, controller, child) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildModernListTile(controller.songs[index], controller),
                childCount: controller.songs.length,
              ),
            );
          },
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
      ],
    );
  }

  Widget _buildModernCard(Song song, SongController controller, BuildContext context) {
    return GestureDetector(
      onTap: () => controller.playSong(song),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C29),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black38, blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: song.coverAssetPath != null
                  ? Image.asset(song.coverAssetPath!, width: 120, height: 120, fit: BoxFit.cover)
                  : Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.orange.shade800, Colors.orange.shade400],
                  ),
                ),
                child: const Icon(Icons.music_note, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                song.title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              song.artist,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            IconButton(
              icon: Icon(
                controller.isFavorite(song) ? Icons.favorite : Icons.favorite_border,
                color: controller.isFavorite(song) ? Colors.redAccent : Colors.white30,
                size: 20,
              ),
              onPressed: () => controller.toggleFavorite(song),
            ),
          ],
        ),
      ),
    );
  }

  // ========== INI YANG DIPERBAIKI (tanpa leadingWidth) ==========
  Widget _buildTrendingItem(Song song, int rank, SongController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C29),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: SizedBox(
          width: 50,
          child: Center(
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  "$rank",
                  style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),
        ),
        title: Text(song.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        subtitle: Text(song.artist, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        trailing: IconButton(
          icon: Icon(
            controller.isFavorite(song) ? Icons.favorite : Icons.favorite_border,
            color: controller.isFavorite(song) ? Colors.redAccent : Colors.white30,
          ),
          onPressed: () => controller.toggleFavorite(song),
        ),
        onTap: () => controller.playSong(song),
      ),
    );
  }

  Widget _buildModernListTile(Song song, SongController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C29),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: song.coverAssetPath != null
              ? Image.asset(song.coverAssetPath!, width: 50, height: 50, fit: BoxFit.cover)
              : Container(
            width: 50,
            height: 50,
            color: Colors.orange.withOpacity(0.2),
            child: const Icon(Icons.music_note, color: Colors.orange),
          ),
        ),
        title: Text(song.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        subtitle: Text(song.artist, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        trailing: IconButton(
          icon: Icon(
            controller.isFavorite(song) ? Icons.favorite : Icons.favorite_border,
            color: controller.isFavorite(song) ? Colors.redAccent : Colors.white30,
          ),
          onPressed: () => controller.toggleFavorite(song),
        ),
        onTap: () => controller.playSong(song),
      ),
    );
  }
}