import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:v_music_player/data_base/audio_model.dart';
import 'package:v_music_player/data_base/database_functions.dart';
import 'package:v_music_player/style/style.dart';
import 'package:v_music_player/widgets/app_bar.dart';
import 'package:v_music_player/widgets/menu_tile.dart';
import 'package:v_music_player/widgets/recent_song_tile.dart';

class Library extends StatefulWidget {
  

 

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  DatabaseFunctions db = DatabaseFunctions.getDatabase();
  List<String> titles = [
    "Playlists",
    "Albums",
  ];
  List<AudioModel> myAudioModelSongs = [];
  List<Audio> audioSongs = [];

  void getRecentSongs()  {
    myAudioModelSongs =  db.getSongs("Recent Songs");
    audioSongs = db.AudioModelToAudio(myAudioModelSongs);
    setState(() {
      audioSongs = audioSongs.reversed.toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getRecentSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsForApp.dark,
      appBar: CustomAppBar.customAppBar("Library"),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
        child: GridView.count(
          crossAxisCount: 1,
          childAspectRatio: 5,
          mainAxisSpacing: 4,
          children: [
            ...titles.map((playlistName) => MenuTile(playlistName)),

            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 40),
              child: Text("Recent Songs", style: StyleForApp.tileDisc),
            ),

           ... audioSongs.map(
              (e) => RecentSongTile(
               audioModel: e,
              audioModelSongs: audioSongs,
               index: audioSongs.indexOf(e),
               playlistName: "Recent Songs",
               setStateOfTheScreen: getRecentSongs,
              ),
            ),
            // ...
          ],
        ),
      ),
    );
  }
}
