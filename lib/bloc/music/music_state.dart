import '../../data/music/music_model.dart';

abstract class MusicState {}

class MusicInitial extends MusicState {}

class MusicLoading extends MusicState {}

class MusicLoaded extends MusicState {
  final List<Music> musicList;

  MusicLoaded(this.musicList);
}

class MusicError extends MusicState {
  final String error;

  MusicError(this.error);
}
