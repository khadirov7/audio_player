import 'package:cloud_firestore/cloud_firestore.dart';
import '../music/music_model.dart';

class MusicRepository {

  Future<List<Music>> fetchMusics() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('musics').get();
    return querySnapshot.docs.map((doc) => Music.fromJson(doc.data())).toList();
  }

  Future<void> addFavorite(Music music) async {
    await FirebaseFirestore.instance.collection('favorites').add(music.toJson());
  }

  Future<void> removeFavorite(String musicId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('favorites')
        .where('id', isEqualTo: musicId)
        .get();
    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<List<Music>> fetchFavorites() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('favorites').get();
    return querySnapshot.docs.map((doc) => Music.fromJson(doc.data())).toList();
  }
}
