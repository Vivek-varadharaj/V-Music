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
  bool prevDone = true;
  bool nextDone = true;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return assetsAudioPlayer.builderCurrent(builder: (context, playing) {
      find(playing.audio.assetAudioPath);

      return currentPlaying != null
          ? Container(
              padding: EdgeInsets.only(top: 10),
              // color: Colors.black,
              width: width,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              duration: Duration(milliseconds: 200),
                              type: PageTransitionType.fade,
                              child: NowPlaying(audioSongsList, 0)));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        
                          // color: ColorsForApp.dark,
                          borderRadius: BorderRadius.circular(10)),
                      height: width < 600 ? 60 : 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                            child: Container(
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.only(right: 20),
                              width: width < 600 ? 60 : 100,
                              child: currentPlaying!.metas.extra!["image"],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(
                                child: Text(
                                  currentPlaying!.metas.title!,
                                  style: width < 600
                                      ? StyleForApp.heading
                                      : StyleForApp.headingLarge,
                                  maxLines: 1,
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
                                    width: width < 600
                                        ? MediaQuery.of(context).size.width *
                                            0.25
                                        : MediaQuery.of(context).size.width *
                                            0.15,
                                    margin: EdgeInsets.only(
                                        right: 20, bottom: 2, left: 10),
                                    child: ProgressBarForSongs(
                                        currentPlaying, false),
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          if (prevDone) {
                                            prevDone = false;
                                            await assetsAudioPlayer.previous();
                                            prevDone = true;
                                          }
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Icon(
                                            FontAwesomeIcons.stepBackward,
                                            color: Colors.white,
                                            size: width < 600 ? 22 : 32,
                                          ),
                                        ),
                                      ),
                                      assetsAudioPlayer.builderIsPlaying(
                                          builder: (context, isPlaying) {
                                        return isPlaying
                                            ? GestureDetector(
                                                onTap: () {
                                                  assetsAudioPlayer.pause();
                                                },
                                                child: Container(
                                                    margin: EdgeInsets.only(
                                                        left: 15),
                                                    child: Icon(
                                                      FontAwesomeIcons
                                                          .pauseCircle,
                                                      color: Colors.white,
                                                      size:
                                                          width < 600 ? 22 : 32,
                                                    )),
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                  assetsAudioPlayer.play();
                                                },
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 15),
                                                  child: Icon(
                                                    FontAwesomeIcons.playCircle,
                                                    color: Colors.white,
                                                    size: width < 600 ? 22 : 32,
                                                  ),
                                                ),
                                              );
                                      }),
                                      GestureDetector(
                                        onTap: () async {
                                          if (nextDone) {
                                            nextDone = false;
                                            await assetsAudioPlayer.next();
                                            nextDone = true;
                                          }
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: 15, right: 20),
                                          child: Icon(
                                            FontAwesomeIcons.stepForward,
                                            color: Colors.white,
                                            size: width < 600 ? 22 : 32,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
            )
          : Container();
    });
  }

//  int? currentIndex;
  Audio? currentPlaying;
  void find(String path) {
    if (audioSongsList.length != 0)
      currentPlaying =
          audioSongsList.firstWhere((element) => element.path == path);
  }
}
