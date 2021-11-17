import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_music_player/style/style.dart';

class ProgressBarForSongs extends StatelessWidget {
  SharedPreferences? prefs;
  Audio? nowPlaying;
  bool label;
  ProgressBarForSongs(this.nowPlaying, this.label);
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.withId("0");

  void getPreference() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return assetsAudioPlayer.builderRealtimePlayingInfos(
      builder: (context, infos) {
        getPreference();
        prefs?.setInt("duration", infos.currentPosition.inMilliseconds);
        return Container(
          height: MediaQuery.of(context).size.height * 0.02,
          child: ProgressBar(
              progress:
                  Duration(milliseconds: infos.currentPosition.inMilliseconds),
              total: Duration(
                  milliseconds: nowPlaying?.metas
                      .extra!["duration"]), //infos.duration.inMilliseconds),
              onSeek: (newPosition) {
                assetsAudioPlayer.seek(newPosition);
              },
              timeLabelTextStyle: TextStyle(color: Colors.white),
              progressBarColor: Colors.white.withOpacity(0.8),
              barCapShape: BarCapShape.square,
              thumbGlowColor: Colors.white,
              thumbRadius: 6,
              thumbGlowRadius: 8,
              thumbColor: Colors.white,
              baseBarColor: Colors.white.withOpacity(0.3),
              timeLabelLocation:
                  label ? TimeLabelLocation.below : TimeLabelLocation.none),
        );
      },
    );
  }
}
