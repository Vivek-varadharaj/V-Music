import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:v_music_player/screens/screen_now_playing.dart';
import 'package:v_music_player/style/style.dart';

class BottomControlForOtherScreens extends StatelessWidget {
 final List<Audio> audioSongsList;
  final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  BottomControlForOtherScreens(this.audioSongsList);

  @override
  Widget build(BuildContext context) {
    return assetsAudioPlayer.builderIsPlaying(builder: (context, isPlaying) {
      return isPlaying ?
           assetsAudioPlayer.builderCurrent(builder: (context, playing) {
              return GestureDetector(
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
                      color: ColorsForApp.goldenLow,
                      borderRadius: BorderRadius.circular(8)),
                  height: 60,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Now Playing",
                          style: StyleForApp.heading,
                        ),
                        Icon(FontAwesomeIcons.stepBackward),
                        assetsAudioPlayer.builderIsPlaying(builder: (context,isPlaying){
                          return GestureDetector(
                            onTap: (){
                              assetsAudioPlayer.stop();
                            },
                            child: Container(
                              child: isPlaying? Icon(FontAwesomeIcons.stop) : Icon(FontAwesomeIcons.play),
                            ),
                          );
                        }),
                        GestureDetector(
                          onTap: (){
                            assetsAudioPlayer.next();
                          },
                          child: Icon(FontAwesomeIcons.stepForward)),
                      ],
                    ),
                  ),
                ),
              );
            })
          : Container(
            height: 0,
            width: 0,
          );
    });
  }
}
