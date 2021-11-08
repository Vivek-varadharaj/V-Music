import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:v_music_player/data_base/audio_model.dart';
import 'package:v_music_player/data_base/database_functions.dart';

class FavoriteToggling extends StatefulWidget {
 final Audio audioModel;

  FavoriteToggling(this.audioModel);

  @override
  _FavoriteTogglingState createState() => _FavoriteTogglingState();
}

class _FavoriteTogglingState extends State<FavoriteToggling> {
  AudioModel? favorite;
  bool isFavorite = false;
  List<Audio> audioSongs = [];
  List<AudioModel> myAudioModelSongs = [];
  DatabaseFunctions db = DatabaseFunctions.getDatabase();
  void decideColor() async {
    myAudioModelSongs = await db.getSongs("Favorites");
    favorite = AudioModel(
        album: widget.audioModel.metas.album,
        id: widget.audioModel.metas.extra!["id"],
        path: widget.audioModel.path,
        title: widget.audioModel.metas.title);

    isFavorite = db.isExists(myAudioModelSongs, favorite);

    setState(() {});
  }

  @override
  void initState() {
    
    super.initState();
    decideColor();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isFavorite) {
          myAudioModelSongs.removeWhere(
              (element) => element.id == widget.audioModel.metas.extra!["id"]);
          db.insertSongs(myAudioModelSongs, "Favorites");
        } else
          db.addToPlaylist(
              audioModel: widget.audioModel,
              playlistName: "Favorites",
              context: context);
        setState(() {
          isFavorite=!isFavorite;
        });
      },
      child: Icon(FontAwesomeIcons.heart,
          color: isFavorite ? Colors.red : Colors.white),
    );
  }
}
