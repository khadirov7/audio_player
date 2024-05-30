class Music {
  final String name;
  final String artist;
  final String picture;
  final String audioFile;

  Music({
    required this.name,
    required this.artist,
    required this.picture,
    required this.audioFile,
  });

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
      name: json['name'],
      artist: json['artist'],
      picture: json['picture'],
      audioFile: json['audio_file'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'artist': artist,
      'picture': picture,
      'audio_file': audioFile,
    };
  }
}
