import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:v_music_player/audio_player/player.dart';
import 'package:v_music_player/data_base/database_functions.dart';
import 'package:v_music_player/screens/screen_now_playing.dart';
import 'package:v_music_player/style/style.dart';

class SongTile extends StatefulWidget {
  final Audio audioModel;
  final List<Audio> audioModelSongs;
  final index;

  SongTile(this.audioModel, this.audioModelSongs, this.index);

  @override
  _SongTileState createState() => _SongTileState();
}

class _SongTileState extends State<SongTile> {
  DatabaseFunctions db = DatabaseFunctions.getDatabase();

  Player assetsAudioPlayer = Player.getAudioPlayer();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        assetsAudioPlayer.openPlaylistInPlayer(
            index: widget.index, audioModelSongs: widget.audioModelSongs);
        Navigator.push(
            context,
            PageTransition(
                duration: Duration(milliseconds: 500),
                type: PageTransitionType.fade,
                child: NowPlaying(widget.audioModelSongs, widget.index)));
        print("Navigated to Screen Now Playing");
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          height: 150,
          width: 150,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.yellow, blurRadius: 2)],
              color: ColorsForApp.light,
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              AspectRatio(
                  aspectRatio: 2 / 2.8,
                  child: Container(
                      child: widget.audioModel.metas.extra!["image"])),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.audioModel.metas.title!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: StyleForApp.tileDisc,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        db.addToPlaylistOrFavorites(
                            context: context, audioModel: widget.audioModel);
                        print("show dialogue");
                      },
                      child: Container(
                        color: Colors.transparent,
                        width: 40,
                        child: Center(
                          child: Icon(
                            FontAwesomeIcons.ellipsisV,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                       widget.audioModel.metas.album! ,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: StyleForApp.tileDisc,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}