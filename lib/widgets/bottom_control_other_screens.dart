import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:page_transition/page_transition.dart';
import 'package:v_music_player/screens/screen_now_playing.dart';
import 'package:v_music_player/style/style.dart';
import 'package:v_music_player/widgets/progress_bar.dart';

// ignore: must_be_immutable
class BottomControlForOtherScreens extends StatelessWidget {
  final List<Audio> audioSongsList;
  final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  BottomControlForOtherScreens(this.audioSongsList);

  @override
  Widget build(BuildContext context) {
    return  assetsAudioPlayer.builderCurrent(builder: (context, playing) {
      find(playing.audio.assetAudioPath);
      return currentPlaying!= null? Container(
        padding: EdgeInsets.only(top: 10),
        color: Colors.black,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
           
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        duration: Duration(milliseconds: 500),
                        type: PageTransitionType.fade,
                        child: NowPlaying(audioSongsList, 0)));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color:ColorsForApp.goldenLow,
                  borderRadius: BorderRadius.circular(10)),
                height: 60,
                
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(right:20),
                        height: 50,
                        width: 55,
                        child: currentPlaying!.metas.extra!["image"] ,),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          child: Text(currentPlaying!.metas.title!,style:StyleForApp.heading,maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                              ),
                        ),
                      ),
                    ),
                  
                    IntrinsicWidth(
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                               Container(
              width: MediaQuery.of(context).size.width*0.25,
              margin: EdgeInsets.only(right: 20,bottom: 2,left: 10),
              
              child: ProgressBarForSongs(currentPlaying,false),
            ),
                            Row(children: [
                                 GestureDetector(
                                onTap: (){
                                  assetsAudioPlayer.previous();
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Icon(FontAwesomeIcons.stepBackward,color: Colors.white,),
                                ),
                              ),
                                          assetsAudioPlayer.builderIsPlaying(builder: (context,isPlaying){
                            return  isPlaying ? GestureDetector(
                              onTap: (){
                                assetsAudioPlayer.pause();
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 15),
                                child: Icon(FontAwesomeIcons.pauseCircle, color: Colors.white,)
                              ),
                            ) : GestureDetector(
                              onTap: (){
                                assetsAudioPlayer.play();
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 15),
                                child: Icon(FontAwesomeIcons.playCircle,color: Colors.white,),
                              ),
                            );
                                          }),
                             GestureDetector(
                                onTap: (){
                                  assetsAudioPlayer.next();
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 15,right: 20),
                                  
                                  child: Icon(FontAwesomeIcons.stepForward,color: Colors.white,),
                                ),
                              ),
                            ],),
                          ],
                        ),
                      ),
                    ),
                   
    
                  ],
                ),
              ),
            ),
          ],
        ),
      ): Container();
    });
  }

  Audio? currentPlaying;
  void find(String path) {
    if(audioSongsList.length!=0)
    currentPlaying =
        audioSongsList.firstWhere((element) => element.path == path);
  }
}
