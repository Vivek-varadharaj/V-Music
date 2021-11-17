import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_music_player/data_base/database_functions.dart';
import 'package:v_music_player/screens/screen_library.dart';
import 'package:v_music_player/screens/screen_playlist_songs.dart';
import 'package:v_music_player/style/style.dart';
import 'package:v_music_player/widgets/app_bar.dart';
import 'package:v_music_player/widgets/bottom_control_panel.dart';
import 'package:v_music_player/widgets/favorite_toggling_widget.dart';
import 'package:v_music_player/widgets/progress_bar.dart';

// ignore: must_be_immutable
class NowPlaying extends StatefulWidget {
 final List<Audio> audioModelSongs;
 final int index;
 
  NowPlaying(this.audioModelSongs, this.index);

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  DatabaseFunctions db = DatabaseFunctions.getDatabase();

  Audio? nowPlaying;
  SharedPreferences? prefs;
  int? last;

  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.withId("0");
 void getPreferences() async{
   prefs  = await SharedPreferences.getInstance();
   setState(() {
     
   });
    
 }
 @override
  void initState() {
    super.initState();
    getPreferences();
    last = widget.audioModelSongs.length-1;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: ColorsForApp.dark,
      appBar: CustomAppBar.customAppBar("Now Playing",context),
      body: Container(

        decoration: BoxDecoration(
              gradient: StyleForApp.bodyTheme,
   
            ),
        padding:
          width < 600 ?  const EdgeInsets.only(top: 8.0, left: 20, right: 20, bottom: 24) : EdgeInsets.only(top: 16.0, left: 40, right: 40, bottom: 48),
        child: assetsAudioPlayer.builderCurrent(builder: (context, playing) {
          nowPlaying = find(widget.audioModelSongs, playing.audio.assetAudioPath);
          int currentIndex = widget.audioModelSongs.indexOf(nowPlaying!);
          db.addToPlaylist(audioModel: nowPlaying, context: context, playlistName: "Recent Songs");//inserting the song to Recent Songs playlist
          
          return Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Container(
                  height: MediaQuery.of(context).size.height*0.04,
                  padding: EdgeInsets.only(top:8),
                child: !assetsAudioPlayer.isShuffling.value? Row(
                  children: [
                    Text("Up Next:", style: StyleForApp.tileDisc, maxLines: 1, overflow: TextOverflow.ellipsis,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:20.0),
                      child: currentIndex+1 < widget.audioModelSongs.length? Text(widget.audioModelSongs[currentIndex+1].metas.title!,style:StyleForApp.tileDisc,): Text("No other Song in the playlist",style: StyleForApp.heading,),
                    ),
                  ],
                ): Container(),
                ),
                Container(
                  child: Center(
                    child: Text(
                      nowPlaying!.metas.title!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: width< 600 ?  StyleForApp.heading : StyleForApp.headingLarge,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Container(
                    
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: nowPlaying!.metas.extra!['image'],
                  ),
                ),
               ProgressBarForSongs(nowPlaying,true),


                assetsAudioPlayer.builderCurrent(
                  builder: (context, playing) {
                    final Audio nowPlaying =
                        find(widget.audioModelSongs, playing.audio.assetAudioPath);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Container(

                        padding: EdgeInsets.symmetric(vertical:8,horizontal: 15),
                        height:  MediaQuery.of(context).size.height * 0.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: ColorsForApp.dark,
                          boxShadow: [BoxShadow(
                            color: ColorsForApp.golden,
                            blurRadius: 0,
                          )]
                        ),
                        child: Center(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                               Container(
                                 padding: EdgeInsets.all(4),
                                 width:60,
                                 child: nowPlaying.metas.extra!["image"],) ,
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30.0),
                                    child: Text(
                                      nowPlaying.metas.title!,
                                      style: width <600 ? StyleForApp.heading : StyleForApp.headingLarge,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                FavoriteToggling(widget.audioModelSongs),
                              ]),
                        ),
                      ),
                    );
                  },
                ),
                BottomControlPannel(currentIndex, last!, prefs),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (){
                          Navigator.push(
                context,
                PageTransition(
                    duration: Duration(milliseconds: 200),
                    type: PageTransitionType.fade,
                    child: PlaylistSongsScreen("All Songs")));
                      },
                      child: Icon(Icons.playlist_add_check_outlined,color:Colors.white,size: 30,)),
                    GestureDetector(
                      onTap:  (){
                          Navigator.push(
                context,
                PageTransition(
                    duration: Duration(milliseconds: 200),
                    type: PageTransitionType.fade,
                    child: PlaylistSongsScreen("Favorites")));
                      },
                      child: Icon(FontAwesomeIcons.heart,color: Colors.white,))
                  ],
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  Audio find(List<Audio> audioModelSongs, String path) {
    return audioModelSongs.firstWhere((element) => element.path == path);
  }
   void setStateOfTheWidget(){
    setState(() {
      
    });
  }
}
