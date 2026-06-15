import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/song_controller.dart';
import '../controllers/user_controller.dart';
import '../models/song_model.dart';
import 'edit_profile_screen.dart';
import 'favorite_songs_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _showAddSongDialog() async {
    final titleController = TextEditingController();
    final artistController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C29),
        title: const Text("Tambah Lagu Baru", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Judul Lagu",
                hintStyle: TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: artistController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Nama Artis",
                hintStyle: TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "⚠️ Pastikan file audio sudah ada di assets/audio/ dengan nama: judul_lagu.mp3 (spasi diganti underscore)",
              style: TextStyle(color: Colors.orange, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty && artistController.text.isNotEmpty) {
                final audioFileName = "audio/${titleController.text.replaceAll(' ', '_')}.mp3";
                final coverFileName = "covers/${titleController.text.replaceAll(' ', '_')}.jpg";
                final newSong = Song(
                  id: DateTime.now().millisecondsSinceEpoch,
                  title: titleController.text,
                  artist: artistController.text,
                  audioPath: audioFileName,
                  coverAssetPath: coverFileName,
                );
                Provider.of<SongController>(context, listen: false).addSong(newSong);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Lagu '${newSong.title}' ditambahkan!")),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text("Tambah"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userController = context.watch<UserController>();
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D15),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage(userController.avatarPath),
                backgroundColor: Colors.grey[800],
              ),
              const SizedBox(height: 20),
              Text(
                userController.userName,
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                userController.userBio,
                style: const TextStyle(color: Colors.white54, fontSize: 14),
              ),
              const SizedBox(height: 30),
              _buildMenuTile(Icons.edit, "Edit Profil", () async {
                await Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));
                // Setelah kembali, UserController sudah otomatis update karena menggunakan shared_preferences
                // Tapi panggil refresh untuk memastikan
                context.read<UserController>().refresh();
              }),
              const SizedBox(height: 10),
              _buildMenuTile(Icons.favorite, "Lagu Favorit", () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoriteSongsScreen()));
              }),
              const SizedBox(height: 10),
              _buildMenuTile(Icons.settings, "Pengaturan", () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
              }),
              const SizedBox(height: 10),
              _buildMenuTile(Icons.add_circle, "Tambah Lagu Baru", _showAddSongDialog,
                  iconColor: Colors.orange),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuTile(IconData icon, String title, VoidCallback onTap, {Color? iconColor}) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFF1C1C29), borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: iconColor ?? Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white30),
      ),
    );
  }
}