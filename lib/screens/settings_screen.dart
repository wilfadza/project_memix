import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifEnabled = true;
  bool _dataSaver = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D15),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Pengaturan"),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SwitchListTile(
            title: const Text("Notifikasi", style: TextStyle(color: Colors.white)),
            value: _notifEnabled,
            activeColor: Colors.orange,
            onChanged: (value) => setState(() => _notifEnabled = value),
          ),
          SwitchListTile(
            title: const Text("Mode Hemat Data", style: TextStyle(color: Colors.white)),
            value: _dataSaver,
            activeColor: Colors.orange,
            onChanged: (value) => setState(() => _dataSaver = value),
          ),
          const Divider(color: Colors.white10),
          _buildPlainTile("Bahasa", "Bahasa Indonesia"),
          _buildPlainTile("Kualitas Audio", "Sangat Tinggi"),
          _buildPlainTile("Tentang Memix", ""),
        ],
      ),
    );
  }

  Widget _buildPlainTile(String title, String subtitle) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: subtitle.isEmpty ? null : Text(subtitle, style: const TextStyle(color: Colors.white54)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white30),
      onTap: () {
        // bisa ditambahkan dialog atau navigasi
      },
    );
  }
}