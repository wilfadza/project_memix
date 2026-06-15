import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/song_controller.dart';
import '../models/song_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = "";
  List<Song> _results = [];

  void _search(SongController controller) {
    setState(() {
      _results = controller.songs
          .where((s) => s.title.toLowerCase().contains(_query.toLowerCase()) ||
          s.artist.toLowerCase().contains(_query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D15),
      appBar: AppBar(
        title: const Text("Temukan", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0D0D15),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Cari lagu atau artis...",
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF1C1C29),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
              ),
              onChanged: (value) {
                _query = value;
                _search(context.read<SongController>());
              },
            ),
          ),
          Expanded(
            child: Consumer<SongController>(
              builder: (context, controller, child) {
                if (_query.isEmpty) {
                  return const Center(child: Text("Ketik sesuatu untuk mencari", style: TextStyle(color: Colors.white54)));
                }
                if (_results.isEmpty) {
                  return const Center(child: Text("Tidak ditemukan", style: TextStyle(color: Colors.white54)));
                }
                return ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final song = _results[index];
                    return ListTile(
                      leading: song.coverAssetPath != null
                          ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.asset(song.coverAssetPath!, width: 40, height: 40, fit: BoxFit.cover))
                          : const Icon(Icons.music_note, color: Colors.orange),
                      title: Text(song.title, style: const TextStyle(color: Colors.white)),
                      subtitle: Text(song.artist, style: const TextStyle(color: Colors.white54)),
                      onTap: () => controller.playSong(song),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}