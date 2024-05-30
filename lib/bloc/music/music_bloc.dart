import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/music_repo.dart';
import 'music_event.dart';
import 'music_state.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  final MusicRepository musicRepository;

  MusicBloc(this.musicRepository) : super(MusicInitial()) {
    on<LoadMusics>(_onLoadMusics);
    on<PlayMusic>(_onPlayMusic);
    on<AddFavorite>(_onAddFavorite);
    on<RemoveFavorite>(_onRemoveFavorite);
    on<LoadFavorites>(_onLoadFavorites);
  }

  void _onLoadMusics(LoadMusics event, Emitter<MusicState> emit) async {
    emit(MusicLoading());
    try {
      final musics = await musicRepository.fetchMusics();
      emit(MusicLoaded(musics));
    } catch (_) {
      emit(MusicInitial());
    }
  }

  void _onPlayMusic(PlayMusic event, Emitter<MusicState> emit) {
    emit(MusicPlaying(event.music));
  }

  void _onAddFavorite(AddFavorite event, Emitter<MusicState> emit) async {
    await musicRepository.addFavorite(event.music);
    emit(FavoriteAdded(event.music));
  }

  void _onRemoveFavorite(RemoveFavorite event, Emitter<MusicState> emit) async {
    await musicRepository.removeFavorite(event.musicId);
    emit(FavoriteRemoved(event.musicId));
  }

  void _onLoadFavorites(LoadFavorites event, Emitter<MusicState> emit) async {
    emit(MusicLoading());
    try {
      final favorites = await musicRepository.fetchFavorites();
      emit(FavoritesLoaded(favorites));
    } catch (_) {
      emit(MusicInitial());
    }
  }
}
