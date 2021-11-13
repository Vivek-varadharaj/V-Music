import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:v_music_player/data_base/audio_model.dart';
import 'package:v_music_player/data_base/database_functions.dart';
import 'package:v_music_player/screens/song_tile_for_adding_song_to_playlist_individually.dart';
import 'package:v_music_player/style/style.dart';
import 'package:v_music_player/widgets/app_bar.dart';

class ScreenAddingIndividualSongsToPlaylist extends StatefulWidget {
  final Function setStateOfScreen;
  final String playlistName;
  ScreenAddingIndividualSongsToPlaylist(
      this.setStateOfScreen, this.playlistName);

  @override
  _ScreenAddingIndividualSongsToPlaylistState createState() =>
      _ScreenAddingIndividualSongsToPlaylistState();
}

class _ScreenAddingIndividualSongsToPlaylistState
    extends State<ScreenAddingIndividualSongsToPlaylist> {
  DatabaseFunctions db = DatabaseFunctions.getDatabase();
  List<Audio> audioSongs = [];
  TextEditingController _controller = TextEditingController();
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    List<AudioModel> myAudioModelSongs = db.getSongs("All Songs");
    audioSongs = db.AudioModelToAudio(myAudioModelSongs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsForApp.dark,
      appBar: CustomAppBar.customAppBar("Add Songs", context),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
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
                      audioSongs = audioSongs;
                    });
                  });
                }),
          ),
          ...audioSongs.map((audioSong) => AddPlaylistSongsFromScreen(
              widget.playlistName,
              widget.setStateOfScreen,
              audioSong,
              audioSongs))
        ],
      ),
    );
  }
}
