

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import 'package:v_music_player/audio_player/player.dart';
import 'package:v_music_player/data_base/audio_model.dart';
import 'package:v_music_player/data_base/database_functions.dart';

import 'package:v_music_player/style/style.dart';

// ignore: must_be_immutable
class AddPlaylistSongsFromScreen extends StatefulWidget {
  final String playlistName;
  final Function setStateOfPlaylistScreen;
  Audio audioModel;
  List<Audio> audioSongs;

  AddPlaylistSongsFromScreen(this.playlistName, this.setStateOfPlaylistScreen,
      this.audioModel, this.audioSongs);

  @override
  _PlaylistSongTileState createState() => _PlaylistSongTileState();
}

class _PlaylistSongTileState extends State<AddPlaylistSongsFromScreen> {
  Player player = Player.getAudioPlayer();
  DatabaseFunctions db = DatabaseFunctions.getDatabase();

  List<AudioModel> playlistSongs = [];
  // AssetsAudioPlayer? assetsAudioPlayer = AssetsAudioPlayer.withId("0");

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    getSongs();
    bool decide = decideIcon();
    return GestureDetector(
      onTap: decide
          ? () async {
              
              db.addToFavorites(
                  audioModel: widget.audioModel,
                  playlistName: widget.playlistName,
                  context: context);
              widget.setStateOfPlaylistScreen();
              setState(() {});
              

              
            }
          : () async {
            
             await db.deleteFromPlaylistFromPlaylistScreen(
                  widget.audioModel, widget.playlistName);
                 widget.setStateOfPlaylistScreen();
             
               setState(() {

                 getSongs();
               });
             
              
            },
      child: Container(
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(color: ColorsForApp.dark, boxShadow: [
          BoxShadow(
            color: ColorsForApp.golden.withOpacity(0.5),
            blurRadius: 6,
          )
        ]),
        height: width <600 ?  65 : 100,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  clipBehavior: Clip.hardEdge,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  width: width < 600 ?60 : 100,
                  child:
                      Center(child: widget.audioModel.metas.extra!["image"])),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                  child: Text(
                    widget.audioModel.metas.title!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: width < 600 ?  StyleForApp.tileDisc : StyleForApp.tileDiscLarge,
                  ),
                ),
              ),
              decide ? add : tick,
            ],
          ),
        ),
      ),
    );
  }

// functions

  void getSongs() {
    
    playlistSongs = db.getSongs(widget.playlistName);
    
   audioSongsInPlaylist  = db.AudioModelToAudio(playlistSongs);
  }

  bool decideIcon() {
    List<AudioModel> songInPlaylist = playlistSongs
        .where((element) => element.id == widget.audioModel.metas.extra!["id"])
        .toList();
    if (songInPlaylist.length == 0)
      return true;
    else
      return false;
  }

  Icon add = Icon(
    Icons.add,
    color: Colors.white,
  );
  Icon tick = Icon(Icons.check_circle, color: Colors.white);
  List <Audio> audioSongsInPlaylist =[];
}
