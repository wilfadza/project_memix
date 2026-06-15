import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../models/song_model.dart';

class SongController with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<Song> _songs = [
    Song(
      id: 1,
      title: "Tanpa Cinta",
      artist: "Tiara Andini",
      audioPath: "audio/tanpa_cinta.mp3",
      coverAssetPath: "covers/tanpa_cinta.jpg",
    ),
    Song(
      id: 2,
      title: "Pesan Terakhir",
      artist: "Lyodra",
      audioPath: "audio/Pesan_Terakhir.mp3",
      coverAssetPath: "covers/pesan_terakhir.jpg",
    ),
    Song(
      id: 3,
      title: "Bawa Dia Kembali",
      artist: "Mahalini",
      audioPath: "audio/Bawa_Dia_Kembali.mp3",
      coverAssetPath: "covers/bawa_dia_kembali.jpg",
    ),
    Song(
      id: 4,
      title: "Confident",
      artist: "Justin Bieber",
      audioPath: "audio/Confident.mp3",
      coverAssetPath: "covers/confident.jpg",
    ),
    Song(
      id: 5,
      title: "Flatline",
      artist: "Justin Bieber",
      audioPath: "audio/Flatline.mp3",
      coverAssetPath: "covers/flatline.jpg",
    ),
  ];

  final List<Song> _favoriteSongs = [];
  Song? _currentSong;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  List<Song> get songs => _songs;
  List<Song> get favoriteSongs => _favoriteSongs;
  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  Duration get duration => _duration;
  Duration get position => _position;

  SongController() {
    _audioPlayer.onDurationChanged.listen((d) {
      _duration = d;
      notifyListeners();
    });
    _audioPlayer.onPositionChanged.listen((p) {
      _position = p;
      notifyListeners();
    });
    _audioPlayer.onPlayerStateChanged.listen((s) {
      _isPlaying = s == PlayerState.playing;
      notifyListeners();
    });
  }

  void addSong(Song newSong) {
    _songs.add(newSong);
    notifyListeners();
  }

  void removeSong(Song song) {
    _songs.removeWhere((s) => s.id == song.id);
    _favoriteSongs.removeWhere((s) => s.id == song.id);
    notifyListeners();
  }

  void toggleFavorite(Song song) {
    if (_favoriteSongs.any((s) => s.id == song.id)) {
      _favoriteSongs.removeWhere((s) => s.id == song.id);
    } else {
      _favoriteSongs.add(song);
    }
    notifyListeners();
  }

  bool isFavorite(Song song) => _favoriteSongs.any((s) => s.id == song.id);

  Future<void> playSong(Song song) async {
    _currentSong = song;
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(song.audioPath));
    notifyListeners();
  }

  void togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
  }

  void playNext() {
    if (_songs.isEmpty) return;
    int currentIndex = _currentSong == null ? -1 : _songs.indexOf(_currentSong!);
    int nextIndex = (currentIndex + 1) % _songs.length;
    playSong(_songs[nextIndex]);
  }

  void playPrevious() {
    if (_songs.isEmpty) return;
    int currentIndex = _currentSong == null ? 0 : _songs.indexOf(_currentSong!);
    int prevIndex = (currentIndex - 1 + _songs.length) % _songs.length;
    playSong(_songs[prevIndex]);
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _currentSong = null;
    _position = Duration.zero;
    _duration = Duration.zero;
    _isPlaying = false;
    notifyListeners();
  }
}