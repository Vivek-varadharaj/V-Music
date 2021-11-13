import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:v_music_player/data_base/audio_model.dart';
import 'package:v_music_player/data_base/database_functions.dart';
import 'package:v_music_player/style/style.dart';
import 'package:v_music_player/widgets/add_songs_individully_to_playlist.dart';
import 'package:v_music_player/widgets/app_bar.dart';

import 'package:v_music_player/widgets/playlist_song_tile_display.dart';

class PlaylistSongsScreen extends StatefulWidget {
  final String playlistName;
  PlaylistSongsScreen(this.playlistName);

  @override
  State<PlaylistSongsScreen> createState() => _PlaylistSongsScreenState();
}

class _PlaylistSongsScreenState extends State<PlaylistSongsScreen> {
  // final Box<List<dynamic>>? allSongsBox = Hive.box("allSongsBox");
  DatabaseFunctions db = DatabaseFunctions.getDatabase();
  List<AudioModel>? audioModelSongs;
  List<Audio>? audioSongs = [];
  void getSongs() {
    audioModelSongs = db.getSongs(widget.playlistName);
    audioSongs = db.AudioModelToAudio(audioModelSongs!);
    if (widget.playlistName == "Recent Songs") {
      setState(() {
        audioSongs = audioSongs!.reversed.toList();
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    getSongs();
    return Scaffold(
      backgroundColor: ColorsForApp.dark,
      appBar: CustomAppBar.customAppBar(widget.playlistName, context),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: audioSongs!.length > 0
              ? ListView(children: [
                  widget.playlistName != "Favorites" &&
                          widget.playlistName != "Recent Songs" &&
                          widget.playlistName != "All Songs"
                      ? AddIndividulSongsToPlaylist(
                          getSongs, widget.playlistName)
                      : Container(),
                  ...audioSongs!
                      .map(
                        (audioSong) => PlaylistSongTile(
                          audioSong,
                          audioSongs!,
                          audioSongs!.indexOf(audioSong),
                          widget.playlistName,
                          getSongs,
                        ),
                      )
                      .toList()
                ])
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    widget.playlistName != "Favorites" &&
                            widget.playlistName != "Recent Songs" &&
                            widget.playlistName != "All Songs"
                        ? AddIndividulSongsToPlaylist(
                            getSongs, widget.playlistName)
                        : Container(),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Text(
                          "No Songs Yet!!!",
                          style: width < 600
                              ? StyleForApp.heading
                              : StyleForApp.headingLarge,
                        ),
                      ),
                    ),
                  ],
                )),
    );
  }
}
