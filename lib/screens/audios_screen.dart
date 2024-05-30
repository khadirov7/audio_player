import 'package:audio_player/screens/favorites_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/music/music_bloc.dart';
import '../bloc/music/music_event.dart';
import '../bloc/music/music_state.dart';
import 'audio_player_screen.dart';

class MusicListScreen extends StatefulWidget {
  const MusicListScreen({super.key});

  @override
  State<MusicListScreen> createState() => _MusicListScreenState();
}

class _MusicListScreenState extends State<MusicListScreen> {
  init() async {
    context.read<MusicBloc>().add(LoadMusics());
  }

  @override
  void initState() {
    init();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<MusicBloc>().add(LoadMusics());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Musics'),
        actions: [
          IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>FavoritesScreen()));
          }, icon: Icon(Icons.favorite_border))
        ],
      ),
      body: BlocBuilder<MusicBloc, MusicState>(
        builder: (context, state) {
          if (state is MusicLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MusicLoaded) {
            return ListView.builder(
              itemCount: state.musics.length,
              itemBuilder: (context, index) {
                final music = state.musics[index];
                return ListTile(
                  title: Text(music.name),
                  subtitle: Text(music.artist),
                  leading: CachedNetworkImage(
                    imageUrl: music.picture,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.account_circle_rounded,
                    ),
                  ),
                  onTap: () {
                    context.read<MusicBloc>().add(PlayMusic(music));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MusicPlayerScreen(music: music),
                      ),
                    );
                    initState();

                  },
                );
              },
            );
          } else {
            return const Center(child: Text('No music available.'));
          }
        },
      ),
    );
  }
}
