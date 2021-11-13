
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_music_player/data_base/database_functions.dart';
import 'package:restart_app/restart_app.dart';
import 'package:v_music_player/style/style.dart';

class Player{
  
   AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer.withId("0");
   DatabaseFunctions db = DatabaseFunctions.getDatabase();
  
   Player.getAudioPlayer();
  static Player? _player;

   factory Player(){
     if(_player==null){
       _player = Player.getAudioPlayer();
       return _player!;
     }
     return _player!;
   }

   AssetsAudioPlayer getAssetsAudio(){
     return _assetsAudioPlayer;
   }
   

  void openPlaylistInPlayer({int? index,List <Audio>? audioModelSongs, BuildContext? context, Audio? audioModel,String? playlistName,Function? setStateOfTheScreen}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool notifications = prefs.getBool("notifications")!;
 
try{
    await _assetsAudioPlayer.open(
        Playlist(
          audios: audioModelSongs,
          startIndex: index!,
          
        ),
        autoStart: true,
        showNotification: notifications,
        loopMode: LoopMode.playlist,
        notificationSettings: NotificationSettings(
          stopEnabled: false
        ));
}catch( e){
  db.deleteFromPlaylist(audioModelSongs!,audioModel!,playlistName!); 
  if(context!=null)
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Selected song is not available, Song removed from playlist"),
          
          
        ));
        setStateOfTheScreen!();
        if(context!=null)
        Navigator.of(context).pop();
        if(playlistName=="All Songs"){
          if(context!=null)
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
   await _assetsAudioPlayer.next();
  }

  void playPrevious() async{
   await _assetsAudioPlayer.previous();
  }

  void pauseCurrent() async{
   await _assetsAudioPlayer.pause();
  }
  


  void openPlaylistInPlayerRecent({int? index,List <Audio>? audioModelSongs, BuildContext? context, Audio? audioModel,String? playlistName,Function? setStateOfTheScreen}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool notifications = prefs.getBool("notifications")!;
    int duration = prefs.getInt("duration")!;
    // getsongs();  
try{
    await _assetsAudioPlayer.open(
        Playlist(
          audios: audioModelSongs,
          startIndex: index!,
          
        ),
        autoStart: false,
        showNotification: notifications,
        loopMode: LoopMode.playlist,
        seek: Duration(milliseconds: duration),
        notificationSettings: NotificationSettings(
          stopEnabled: false
          
        ));
}catch( e){
  db.deleteFromPlaylist(audioModelSongs!,audioModel!,playlistName!); 
  if(context!=null)
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Selected song is not available, Song removed from playlist"),
          
          
        ));
        setStateOfTheScreen!();
        if(context!=null)
        Navigator.of(context).pop();
        if(playlistName=="All Songs"){
          if(context!=null)
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

  
}


