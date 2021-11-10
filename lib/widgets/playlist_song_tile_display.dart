import 'dart:io' as io;

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:v_music_player/audio_player/player.dart';
import 'package:v_music_player/data_base/audio_model.dart';
import 'package:v_music_player/data_base/database_functions.dart';
import 'package:v_music_player/screens/screen_now_playing.dart';
import 'package:v_music_player/style/style.dart';

class PlaylistSongTile extends StatefulWidget {
  final Audio audioModel;
  final List<Audio> audioModelSongs;
  final index;
 final String? playlistName;
 final Function setStateOfPlaylistScreen;

  PlaylistSongTile(this.audioModel, this.audioModelSongs, this.index,
      this.playlistName, this.setStateOfPlaylistScreen);

  @override
  _PlaylistSongTileState createState() => _PlaylistSongTileState();
}

class _PlaylistSongTileState extends State<PlaylistSongTile> {
  Player player = Player.getAudioPlayer();
  DatabaseFunctions db = DatabaseFunctions.getDatabase();
  Audio? audioModel;
  // AssetsAudioPlayer? assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  @override
  void initState() {
  
    super.initState();

    getSongs();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
       
          player.openPlaylistInPlayer(
            index: widget.index, audioModelSongs: widget.audioModelSongs);
        Navigator.push(
            context,
            PageTransition(
                duration: Duration(milliseconds: 500),
                type: PageTransitionType.fade,
                child: NowPlaying(widget.audioModelSongs, widget.index)));
        
        
        print("Navigated to Screen Now Playing");
      },
      child: Container(
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(color: ColorsForApp.dark, boxShadow: [
          BoxShadow(
            color: ColorsForApp.golden.withOpacity(0.5),
            blurRadius: 6,
          )
        ]),
        height: 65,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  clipBehavior: Clip.hardEdge,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  width: 60,
                  child: Center(child: audioModel!.metas.extra!["image"])),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                  child: Text(
                    widget.audioModel.metas.title!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: StyleForApp.tileDisc,
                  ),
                ),
              ),
              GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              backgroundColor: ColorsForApp.goldenLow,
                              title: Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      db.deleteFromPlaylist(widget.audioModelSongs,widget.audioModel,widget.playlistName!); 
                                      widget.setStateOfPlaylistScreen(); // deletes from playlist . written below this class
                                      Navigator.of(context).pop();
                                    },
                                    title: Text(
                                      "Delete from playlist",
                                      style: StyleForApp.tileDisc,
                                    ),
                                    trailing: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                  widget.playlistName != "Favorites"// checks this condition so that add to favorites option will not be available in favorites page
                                      ? ListTile(
                                          onTap: () {
                                            db.addToPlaylist(        //database function to  add to playlist here the playlist name is "Favorites"
                                                context: context,
                                                audioModel: audioModel,
                                                playlistName: "Favorites");
                                          },
                                          title: Text(
                                            "Add to Favorites",
                                            style: StyleForApp.tileDisc,
                                          ),
                                          trailing: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            ));
                    
                  },
                  child: Container(
                    color: ColorsForApp.golden.withOpacity(0.2),
                    width: 40,
                    height: 60,
                    child: Center(
                      child: Icon(
                        FontAwesomeIcons.ellipsisV,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

// functions

  void getSongs() {
    //function for getting the song from widget top class to beneath
    audioModel = widget.audioModel;
    print(audioModel);
    print(audioModel!.metas.extra!["image"]);
  }

  void deleteFromPlaylist() {
    List<AudioModel> myAudioModelSongs =
        db.audioToMyAudioModel(widget.audioModelSongs);
    myAudioModelSongs
        .removeWhere((element) => element.id == audioModel!.metas.extra!['id']);
    db.insertSongs(myAudioModelSongs, widget.playlistName!);
    widget.setStateOfPlaylistScreen();
    
  }
}
