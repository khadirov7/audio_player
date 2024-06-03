import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/music/music_bloc.dart';
import '../bloc/music/music_event.dart';
import '../bloc/music/music_state.dart';
import 'audio_player_screen.dart';

class AllAudiosScreen extends StatefulWidget {
  const AllAudiosScreen({super.key, this.onMusicChosen});

  final Function(String)? onMusicChosen;

  @override
  State<AllAudiosScreen> createState() => _AllAudiosScreenState();
}

class _AllAudiosScreenState extends State<AllAudiosScreen> {
  bool isLike = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MusicBloc()..add(FetchMusic()),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('My Musics',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
        ),
        body: BlocBuilder<MusicBloc, MusicState>(
          builder: (context, state) {
            if (state is MusicLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MusicLoaded) {
              return ListView.builder(
                itemCount: state.musicList.length,
                itemBuilder: (context, index) {
                  final song = state.musicList[index];
                  return ListTile(
                    trailing: IconButton(onPressed: (){
                      setState(() {
                        isLike = !isLike;
                      });
                    }, icon: const Icon(Icons.favorite_border,color: Colors.white,)),
                    leading: const Icon(Icons.music_note_outlined,color: Colors.lightBlue,size: 30,),
                    title: Text(song.title,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w700)),
                    subtitle: Text(song.artist,style: const TextStyle(color: Colors.white)),
                    onTap: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => MusicPlayerScreen(music: song,)));
                    },
                  );
                },
              );
            } else if (state is MusicError) {
              return Center(child: Text(state.error));
            }
            return const Center(child: Text('NO',style: TextStyle(color: Colors.white)));
          },
        ),
      ),
    );
  }
}
