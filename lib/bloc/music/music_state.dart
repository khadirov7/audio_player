
import '../../data/music/music_model.dart';

abstract class MusicState {}

class MusicInitial extends MusicState {}

class MusicLoading extends MusicState {}

class MusicLoaded extends MusicState {
  final List<Music> musics;

  MusicLoaded(this.musics);
}

class MusicPlaying extends MusicState {
  final Music music;

  MusicPlaying(this.music);
}

class FavoriteAdded extends MusicState {
  final Music music;

  FavoriteAdded(this.music);
}

class FavoriteRemoved extends MusicState {
  final String musicId;

  FavoriteRemoved(this.musicId);
}

class FavoritesLoaded extends MusicState {
  final List<Music> favorites;

  FavoritesLoaded(this.favorites);
}
