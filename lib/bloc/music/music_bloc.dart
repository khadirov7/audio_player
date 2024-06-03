import 'package:bloc/bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../data/music/music_model.dart';
import 'music_event.dart';
import 'music_state.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  MusicBloc() : super(MusicInitial()) {
    on<FetchMusic>(getMusics);
  }

  void getMusics(FetchMusic event, Emitter<MusicState> emit) async {
    emit(MusicLoading());
    try {
      List<SongModel> songs = await _audioQuery.querySongs();
      List<Music> musicList = songs.map((song) {
        return Music(
          data: song.data,
          id: song.id.toString(),
          title: song.title,
          artist: song.artist ?? "Unknown",
          uri: song.uri ?? "",
        );
      }).toList();
      emit(MusicLoaded(musicList));
    } catch (e) {
      emit(MusicError(e.toString()));
    }
  }
}
