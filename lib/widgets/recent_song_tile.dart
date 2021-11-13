import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:v_music_player/audio_player/player.dart';
import 'package:v_music_player/data_base/audio_model.dart';
import 'package:v_music_player/data_base/database_functions.dart';
import 'package:v_music_player/screens/screen_now_playing.dart';
import 'package:v_music_player/style/style.dart';
import 'dart:io';

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
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: 50,
      padding: const EdgeInsets.all(1.5),
      child: GestureDetector(
        onTap:() async{
        
        try{
          player.openPlaylistInPlayer(index:index, audioModelSongs: audioModelSongs,context: context, audioModel: audioModel,setStateOfTheScreen: setStateOfTheScreen,playlistName: playlistName);
          Navigator.push(
              context,
              PageTransition(
                duration: Duration(milliseconds: 500),
                  type: PageTransitionType.fade,
                  child: NowPlaying(audioModelSongs!, index!)));
        }  catch(e){
          
        }
        }
        ,
        child: Container(
          padding:  EdgeInsets.only(left: 4,top: 4,bottom: 4),
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
                width: width < 600 ? 60 : 100,
                child: audioModel!.metas.extra!["image"],
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal:15.0),
                  child: Text(audioModel!.metas.title!,overflow: TextOverflow.ellipsis,style: width < 600  ? StyleForApp.tileDisc : StyleForApp.tileDiscLarge,),
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

  Future<bool> isItAvailable()async{
    
    
    File a = File(audioModelSongs![index!].path);
    print("awaiting ${ await a.exists()}");
    List<AudioModel> allSongs =  await db.getSongs("All Songs");
    List<AudioModel> theSong = allSongs.where((element) => element.path==audioModelSongs![index!].path).toList();
    if(theSong.length>0){
      return true;
    }
    else return false;
  }
}