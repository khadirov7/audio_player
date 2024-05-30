import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../data/music/music_model.dart';
import 'audios_screen.dart';

class MusicPlayerScreen extends StatefulWidget {
  final Music music;

  const MusicPlayerScreen({required this.music, super.key});

  @override
  MusicPlayerScreenState createState() => MusicPlayerScreenState();
}

class MusicPlayerScreenState extends State<MusicPlayerScreen> {
  late AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer.setUrl(widget.music.audioFile);
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Playing'),
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 60,
          ),
          // CircleAvatar(
          //   backgroundImage: NetworkImage(widget.music.picture),
          // ),
          CachedNetworkImage(
            height: 250,
            width: 250,
            imageUrl: widget.music.picture,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) =>
                const Icon(Icons.account_circle_rounded,size: 250,),
          ),
          // Image.network(widget.music.picture, height: 250, width: 250,),
          const SizedBox(
            height: 20,
          ),
          Text(widget.music.name,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(widget.music.artist, style: const TextStyle(fontSize: 20)),
          const SizedBox(
            height: 20,
          ),
          StreamBuilder<Duration?>(
            stream: audioPlayer.durationStream,
            builder: (context, snapshot) {
              final duration = snapshot.data ?? Duration.zero;
              return StreamBuilder<Duration>(
                stream: audioPlayer.positionStream,
                builder: (context, snapshot) {
                  var position = snapshot.data ?? Duration.zero;
                  if (position > duration) {
                    position = duration;
                  }
                  return Column(
                    children: [
                      Row(
                        
                      ),
                      Slider(
                        value: position.inSeconds.toDouble(),
                        max: duration.inSeconds.toDouble(),
                        onChanged: (value) {
                          audioPlayer.seek(Duration(seconds: value.toInt()));
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "${duration.inMinutes.toString()}:${duration.inSeconds.toString()}"),
                            Text(
                                "${position.inMinutes.toString()}:${position.inSeconds.toString()}")
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.replay_10),
                onPressed: () => audioPlayer.seek(
                  audioPlayer.position - const Duration(seconds: 15),
                ),
              ),
              StreamBuilder<PlayerState>(
                stream: audioPlayer.playerStateStream,
                builder: (context, snapshot) {
                  final playerState = snapshot.data;
                  final processingState = playerState?.processingState;
                  final playing = playerState?.playing;
                  if (playing != true) {
                    return IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () {
                        audioPlayer.play();
                      },
                    );
                  } else if (processingState != ProcessingState.completed) {
                    return IconButton(
                      icon: const Icon(Icons.pause),
                      onPressed: () {
                        audioPlayer.pause();
                      },
                    );
                  } else {
                    return IconButton(
                      icon: const Icon(Icons.replay),
                      onPressed: () {
                        audioPlayer.seek(Duration.zero);
                      },
                    );
                  }
                },
              ),
              IconButton(
                  icon: const Icon(Icons.forward_10),
                  onPressed: () {
                    audioPlayer.seek(
                      audioPlayer.position + const Duration(seconds: 15),
                    );
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
