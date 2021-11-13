import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:v_music_player/data_base/audio_model.dart';
import 'package:v_music_player/data_base/database_functions.dart';
import 'package:v_music_player/style/style.dart';
import 'package:v_music_player/widgets/app_bar.dart';
import 'package:v_music_player/widgets/recent_song_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen();

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseFunctions db = DatabaseFunctions.getDatabase();
  List<Audio> audioSongs = [];
  TextEditingController _controller = TextEditingController();
  Timer? _timer;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ColorsForApp.dark,
      appBar: CustomAppBar.customAppBar("Search"),
      body: Padding(
        padding: width <600 ? EdgeInsets.only(top :8.0,left: 8,right: 8,) :  EdgeInsets.only(top :16.0,left: 16,right: 8,) ,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric( vertical: 8),
              child: TextField(
                controller: _controller,
                style: StyleForApp.tileDisc,
                decoration: InputDecoration(
                  labelText: "Search",
                  labelStyle: StyleForApp.tileDisc,
                  suffixIcon: Icon(
                    FontAwesomeIcons.search,
                    color: ColorsForApp.golden.withOpacity(0.5),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: ColorsForApp.golden.withOpacity(0.5), width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: ColorsForApp.golden.withOpacity(0.5), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: ColorsForApp.golden.withOpacity(0.5), width: 1),
                  ),
                ),
                onChanged: (keyword) async {
                  if (_timer != null) {
                    _timer!.cancel();
                  }

                  List<AudioModel> myAudioModelSongs = db.getSongs("All Songs");

                  _timer = Timer(Duration(seconds: 1), () {
                    audioSongs = db.AudioModelToAudio(myAudioModelSongs);
                    audioSongs = audioSongs
                        .where((element) => element.metas.title!
                            .toUpperCase()
                            .startsWith(keyword.toUpperCase()))
                        .toList();
                    setState(() {
                      if (keyword == "") {
                        audioSongs = [];
                      }
                      audioSongs = audioSongs;
                    });
                  });
                },
              ),
            ),
            ...audioSongs.map((audioSong) => RecentSongTile(
                  audioModel: audioSong,
                  audioModelSongs: audioSongs,
                  index: audioSongs.indexOf(audioSong),
                ))
          ],
        ),
      ),
    );
  }
}
