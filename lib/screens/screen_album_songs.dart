import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:v_music_player/data_base/audio_model.dart';
import 'package:v_music_player/data_base/database_functions.dart';
import 'package:v_music_player/style/style.dart';
import 'package:v_music_player/widgets/app_bar.dart';
import 'package:v_music_player/widgets/recent_song_tile.dart';

class AlbumSongsScreen extends StatefulWidget {
 final String albumName;
  AlbumSongsScreen(this.albumName);

  @override
  State<AlbumSongsScreen> createState() => _AlbumSongsScreenState();
}

class _AlbumSongsScreenState extends State<AlbumSongsScreen> {
  List<AudioModel> myAudioModelSongs = [];

  List<Audio> audioSongs = [];

  DatabaseFunctions db = DatabaseFunctions.getDatabase();

   getSongs() async {
    myAudioModelSongs = await db.getSongs("All Songs");
    myAudioModelSongs = await myAudioModelSongs
        .where((audioModel) => audioModel.album == widget.albumName)
        .toList();
    audioSongs = await db.AudioModelToAudio(myAudioModelSongs);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getSongs();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsForApp.dark ,
      appBar: CustomAppBar.customAppBar(widget.albumName),
      body:  GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: 5.5,
                  mainAxisSpacing: 8,
                  children: [
          ...audioSongs.map(
            (audioSong) => RecentSongTile(
             audioModel: audioSong,
             audioModelSongs: audioSongs,
             index : audioSongs.indexOf(audioSong),
            ),
          ),
          Container(),
        ],
      ),
    );
  }
}
