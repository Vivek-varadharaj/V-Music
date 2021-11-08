
import 'package:assets_audio_player/assets_audio_player.dart';

class Player{
   AssetsAudioPlayer? assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  
   Player.getAudioPlayer();
  static Player? player;

   factory Player(){
     if(player==null){
       player = Player.getAudioPlayer();
       return player!;
     }
     return player!;
   }
   

  void openPlaylistInPlayer({int? index,List <Audio>? audioModelSongs}) async {
    // getsongs();

    await assetsAudioPlayer!.open(
        Playlist(
          audios: audioModelSongs,
          startIndex: index!,
        ),
        autoStart: true,
        showNotification: true);
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


