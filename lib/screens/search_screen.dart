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
  final TextEditingController _searchController = TextEditingController();
  List<Song> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    final songs = Provider.of<SongController>(context, listen: false).songs;
    setState(() {
      _searchResults = songs.where((song) {
        return song.title.toLowerCase().contains(query) ||
            song.artist.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D15),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Cari musik, artis, atau album...",
                  hintStyle: const TextStyle(color: Colors.white30),
                  prefixIcon: const Icon(Icons.search, color: Colors.orange),
                  filled: true,
                  fillColor: const Color(0xFF1C1C29),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _searchResults.isEmpty && _searchController.text.isNotEmpty
                    ? const Center(child: Text("Tidak ditemukan", style: TextStyle(color: Colors.white54)))
                    : ListView.builder(
                  itemCount: _searchResults.isEmpty && _searchController.text.isEmpty
                      ? Provider.of<SongController>(context).songs.length
                      : _searchResults.length,
                  itemBuilder: (context, i) {
                    final song = _searchResults.isEmpty && _searchController.text.isEmpty
                        ? Provider.of<SongController>(context).songs[i]
                        : _searchResults[i];
                    return _buildSongTile(song, context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSongTile(Song song, BuildContext context) {
    final controller = Provider.of<SongController>(context, listen: false);
    return Card(
      color: const Color(0xFF1C1C29),
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.orange.shade700, Colors.orange.shade400]),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.music_note, color: Colors.white),
        ),
        title: Text(song.title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(song.artist, style: const TextStyle(color: Colors.white54)),
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