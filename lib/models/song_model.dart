class Song {
  final int id;
  final String title;
  final String artist;
  final String audioPath;
  final String? coverAssetPath; // path ke file cover di assets, misal "covers/flatline.jpg"

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.audioPath,
    this.coverAssetPath,
  });
}