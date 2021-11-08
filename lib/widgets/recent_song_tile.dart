import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:v_music_player/audio_player/player.dart';
import 'package:v_music_player/data_base/database_functions.dart';
import 'package:v_music_player/screens/screen_now_playing.dart';
import 'package:v_music_player/style/style.dart';
import 'dart:io' as io;

// ignore: must_be_immutable
class RecentSongTile extends StatelessWidget {
  String? playlistName;
 final Audio? audioModel;
  List <Audio>? audioModelSongs=[];
  int? index;
  Function?  setStateOfTheScreen;
  RecentSongTile({this.audioModel,this.audioModelSongs,this.index,this.playlistName,this.setStateOfTheScreen});
  Player player = Player.getAudioPlayer();
  DatabaseFunctions db = DatabaseFunctions.getDatabase();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(1.5),
      child: GestureDetector(
        onTap:() async{
          bool isAvailable = await io.File(audioModelSongs![index!].path).exists();
        if(isAvailable){
          player.openPlaylistInPlayer(index:index, audioModelSongs: audioModelSongs);
          Navigator.push(
              context,
              PageTransition(
                duration: Duration(milliseconds: 500),
                  type: PageTransitionType.fade,
                  child: NowPlaying(audioModelSongs!, index!)));
        }  else{
          db.deleteFromPlaylist(audioModelSongs!,audioModel!,playlistName!); 
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Selected song is not available, Song removed from playlist"),
          
        ));
        setStateOfTheScreen!();
        }
        }
        ,
        child: Container(
          padding: EdgeInsets.only(left: 4,top: 4,bottom: 4),
          decoration: BoxDecoration(
            color: Colors.black,
            boxShadow: [BoxShadow(
              color: ColorsForApp.golden.withOpacity(0.5),
              blurRadius: 4,
            )]
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 60,
                child: audioModel!.metas.extra!["image"],
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal:15.0),
                  child: Text(audioModel!.metas.title!,overflow: TextOverflow.ellipsis,style: StyleForApp.tileDisc,),
                ),
              ),
              Expanded(
                flex: 0,
                child: GestureDetector(
                  onTap: (){
                    db.addToPlaylistOrFavorites(context: context,audioModel: audioModel);
                  },
                  child: Container(
                    height: 60,
                    color:Colors.transparent,
                    width: 40,
                    child: Icon(FontAwesomeIcons.ellipsisV,color: Colors.white,size: 18,)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}