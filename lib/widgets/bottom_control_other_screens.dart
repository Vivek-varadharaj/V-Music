import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
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
      return isPlaying
          ? assetsAudioPlayer.builderCurrent(builder: (context, playing) {
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
                      color: ColorsForApp.golden,
                      borderRadius: BorderRadius.circular(8)),
                  height: 40,
                  child: Center(
                    child: Text(
                      "Now Playing",
                      style: StyleForApp.heading,
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
