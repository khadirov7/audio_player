import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../data/music/music_model.dart';

class MusicPlayerScreen extends StatefulWidget {
  final Music music;

  const MusicPlayerScreen({required this.music, super.key});

  @override
  MusicPlayerScreenState createState() => MusicPlayerScreenState();
}

class MusicPlayerScreenState extends State<MusicPlayerScreen> {
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  double _currentSliderValue = 0.0;
  Duration currentDuration = Duration.zero;
  Duration totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
  }


  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Playing',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700)),
        leading: IconButton(
          onPressed: ()async {
            await audioPlayer.pause();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios,color: Colors.white,),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 60),
          Center(
            child: CachedNetworkImage(
              height: 350,
              width: 350,
              imageUrl: widget.music.id,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
              const Icon(Icons.account_circle_rounded, size: 350,color: Colors.greenAccent,),
            ),
          ),
          const SizedBox(height: 20),
          Text(widget.music.title,
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white)),
          Text(widget.music.artist, style: const TextStyle(fontSize: 20,color: Colors.white)),
          const SizedBox(height: 20),
          Column(
            children: [
              Slider(
                activeColor: Colors.greenAccent,
                value: _currentSliderValue,
                max: 0,
                onChanged: (value) async {
                  setState(() {
                    _currentSliderValue = value;
                  });
                  await audioPlayer
                      .seek(Duration(milliseconds: value.toInt()));
                },
              ),
             const Padding(
                padding:  EdgeInsets.symmetric(horizontal: 22.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("00:00",style:  TextStyle(color: Colors.white,fontWeight: FontWeight.w700)),
                    Text("00:00",style:  TextStyle(color: Colors.white,fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.replay_10,color: Colors.white,size: 45,),
                onPressed: () async {
                  setState(() {
                  });
                  final newPosition =
                  currentDuration.inSeconds - 10 < 0
                      ? Duration.zero
                      : Duration(seconds: currentDuration.inSeconds - 10);
                  await audioPlayer.seek(newPosition);
                },
              ),
              IconButton(
                onPressed: () async {
                  if (isPlaying) {
                    await audioPlayer.pause();
                  } else {
                    debugPrint("DATAAAA: ${widget.music.data}");
                    await audioPlayer.play(DeviceFileSource(widget.music.data));
                  }
                  setState(() {
                    isPlaying = !isPlaying;
                  });
                },
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow,color: Colors.white,size: 45),
              ),
              IconButton(
                icon: const Icon(Icons.forward_10,color: Colors.white,size: 45),
                onPressed: () async {
                  setState(() {
                  });
                  final second = Duration(
                      seconds: currentDuration.inSeconds + 10);
                  if (second <= totalDuration) {
                    await audioPlayer.seek(second);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
