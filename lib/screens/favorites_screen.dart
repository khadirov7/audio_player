import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/music/music_bloc.dart';
import '../bloc/music/music_event.dart';
import '../bloc/music/music_state.dart';
import 'audio_player_screen.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings screen
            },
          ),
        ],
      ),
      body: BlocBuilder<MusicBloc, MusicState>(
        builder: (context, state) {
          if (state is MusicLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavoritesLoaded) {
            final favorites = state.favorites;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final music = favorites[index];
                      return ListTile(
                        leading: Image.network(music.picture, width: 50, height: 50, fit: BoxFit.cover),
                        title: Text(music.name),
                        subtitle: Text(music.artist),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            BlocProvider.of<MusicBloc>(context).add(RemoveFavorite(music.audioFile));
                          },
                        ),
                        onTap: () {
                          BlocProvider.of<MusicBloc>(context).add(PlayMusic(music));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MusicPlayerScreen(music: music),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                BlocBuilder<MusicBloc, MusicState>(
                  builder: (context, state) {
                    if (state is MusicPlaying) {
                      return Container(
                        color: Colors.black12,
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Image.network(state.music.picture, width: 50, height: 50, fit: BoxFit.cover),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(state.music.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Text(state.music.artist, style: TextStyle(fontSize: 14)),
                              ],
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.pause),
                              onPressed: () {
                                // Implement pause functionality
                              },
                            ),
                          ],
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              ],
            );
          } else {
            return const Center(child: Text('No favorites yet'));
          }
        },
      ),
    );
  }
}
