
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_music_player/data_base/database_functions.dart';
import 'package:restart_app/restart_app.dart';
import 'package:v_music_player/style/style.dart';

class Player{
  
   AssetsAudioPlayer? assetsAudioPlayer = AssetsAudioPlayer.withId("0");
   DatabaseFunctions db = DatabaseFunctions.getDatabase();
  
   Player.getAudioPlayer();
  static Player? player;

   factory Player(){
     if(player==null){
       player = Player.getAudioPlayer();
       return player!;
     }
     return player!;
   }
   

  void openPlaylistInPlayer({int? index,List <Audio>? audioModelSongs, BuildContext? context, Audio? audioModel,String? playlistName,Function? setStateOfTheScreen}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool notifications = prefs.getBool("notifications")!;
    // getsongs();  
try{
    await assetsAudioPlayer!.open(
        Playlist(
          audios: audioModelSongs,
          startIndex: index!,
        ),
        autoStart: true,
        showNotification: notifications);
}catch( e){
  db.deleteFromPlaylist(audioModelSongs!,audioModel!,playlistName!); 
           ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
          content: Text("Selected song is not available, Song removed from playlist"),
          
          
        ));
        setStateOfTheScreen!();
        Navigator.of(context).pop();
        if(playlistName=="All Songs"){
          showDialog(context: context, builder: (context)=>
          AlertDialog(
            backgroundColor: ColorsForApp.golden,
            title: Text("Song Not Found", style: StyleForApp.heading,),
            content:Text("Fetching the songs again",style: StyleForApp.tileDisc,),
           
          )
          );
          Future.delayed(Duration(milliseconds: 2000), (){
            Restart.restartApp();
          });
          
        }
}
  }

  void playNext() async{
   await assetsAudioPlayer!.next();
  }

  void playPrevious() async{
   await assetsAudioPlayer!.previous();
  }

  void pauseCurrent() async{
   await assetsAudioPlayer!.pause();
  }

  
}


