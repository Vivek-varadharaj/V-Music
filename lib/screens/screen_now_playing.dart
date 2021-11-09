import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:v_music_player/data_base/database_functions.dart';
import 'package:v_music_player/style/style.dart';
import 'package:v_music_player/widgets/app_bar.dart';
import 'package:v_music_player/widgets/bottom_control_panel.dart';
import 'package:v_music_player/widgets/favorite_toggling_widget.dart';

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

  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.withId("0");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsForApp.dark,
      appBar: CustomAppBar.customAppBar("Now Playing"),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 8.0, left: 20, right: 20, bottom: 24),
        child: assetsAudioPlayer.builderCurrent(builder: (context, playing) {
          nowPlaying = find(widget.audioModelSongs, playing.audio.assetAudioPath);
          db.addToPlaylist(audioModel: nowPlaying, context: context, playlistName: "Recent Songs");//inserting the song to Recent Songs playlist

          return Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0,top: 10,right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          child: Center(
                            child: Text(
                              nowPlaying!.metas.title!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: StyleForApp.heading,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.yellow,
                        blurRadius: 4,
                      )
                    ]),
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: nowPlaying!.metas.extra!['image'],
                  ),
                ),
                assetsAudioPlayer.builderRealtimePlayingInfos(
                  builder: (context, infos) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.02,
                      child: ProgressBar(
                        progress: Duration(
                            milliseconds: infos.currentPosition.inMilliseconds),
                        total: Duration(
                            milliseconds: nowPlaying!.metas.extra!["duration"]), //infos.duration.inMilliseconds),
                        onSeek: (newPosition) {
                          assetsAudioPlayer.seek(newPosition);
                        },
                        timeLabelTextStyle:
                            TextStyle(color: ColorsForApp.golden),
                        progressBarColor: ColorsForApp.golden.withOpacity(0.8),
                        barCapShape: BarCapShape.square,
                        thumbGlowColor: ColorsForApp.golden,
                        thumbRadius: 6,
                        thumbGlowRadius: 8,
                        thumbColor: ColorsForApp.golden,
                        baseBarColor: ColorsForApp.golden.withOpacity(0.3),
                      ),
                    );
                  },
                ),
                assetsAudioPlayer.builderCurrent(
                  builder: (context, playing) {
                    final Audio nowPlaying =
                        find(widget.audioModelSongs, playing.audio.assetAudioPath);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Container(

                        padding: EdgeInsets.all(8),
                        height: MediaQuery.of(context).size.height * 0.1,
                        decoration: BoxDecoration(
                          color: ColorsForApp.dark,
                          boxShadow: [BoxShadow(
                            color: ColorsForApp.golden,
                            blurRadius: 4,
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
                                      style: StyleForApp.heading,
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
                BottomControlPannel(),
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
