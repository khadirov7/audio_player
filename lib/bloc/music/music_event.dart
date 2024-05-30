import '../../data/music/music_model.dart';

abstract class MusicEvent {}

class LoadMusics extends MusicEvent {}

class PlayMusic extends MusicEvent {
  final Music music;

  PlayMusic(this.music);
}

class AddFavorite extends MusicEvent {
  final Music music;

  AddFavorite(this.music);
}

class RemoveFavorite extends MusicEvent {
  final String musicId;

  RemoveFavorite(this.musicId);
}

class LoadFavorites extends MusicEvent {}
