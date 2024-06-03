import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class MusicRepository {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  Future<List<SongModel>> fetchMusics() async {
    if (!await _hasPermission()) {
      throw Exception("Storage permission not granted");
    }
    return await _audioQuery.querySongs();
  }

  Future<bool> _hasPermission() async {
    if (await Permission.storage.request().isGranted) {
      return true;
    }
    return false;
  }
}
