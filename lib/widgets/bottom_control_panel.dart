import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_music_player/audio_player/player.dart';
import 'package:v_music_player/style/style.dart';

class BottomControlPannel extends StatefulWidget {
  int index;
  int last;

  SharedPreferences? prefs;
  BottomControlPannel(this.index, this.last, this.prefs);
  @override
  _BottomControlPannelState createState() => _BottomControlPannelState();
}

class _BottomControlPannelState extends State<BottomControlPannel> {
  bool? shuffled;
  bool? looped;
  bool prevDone = true;
  bool nextDone = true;

  void getModePreference() async {
    looped = widget.prefs!.getBool("loop")!;
    shuffled = widget.prefs!.getBool("shuffle")!;
  }

  Player player = Player();

  AssetsAudioPlayer? assetsAudioPlayer;
  @override
  void initState() {
    shuffled = false;
    looped = false;
    super.initState();

    assetsAudioPlayer = player.getAssetsAudio();
  }

  Timer? _timer;
  @override
  Widget build(BuildContext context) {
    return assetsAudioPlayer!.builderCurrent(
        builder: (context, currentPlaying) {
      return Container(
        decoration: BoxDecoration(
            
            // color: ColorsForApp.dark,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            )),
        padding: EdgeInsets.symmetric(horizontal: 30),
        height: MediaQuery.of(context).size.height * 0.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
                onTap: () async {
                  if (!looped!) {
                    assetsAudioPlayer!.setLoopMode(LoopMode.single);

                    setState(() {
                      looped = true;
                    });
                  } else {
                    assetsAudioPlayer!.setLoopMode(LoopMode.playlist);

                    setState(() {
                      looped = false;
                    });
                  }
                },
                child: assetsAudioPlayer!.loopMode.value == LoopMode.single
                    ? Container(
                        color: Colors.transparent,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Icon(
                          Icons.repeat_one,
                          color: Colors.white,
                        ),
                      )
                    : Container(
                        color: Colors.transparent,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Icon(
                          Icons.repeat_one,
                          color: Colors.grey,
                        ),
                      )),
            GestureDetector(
                onTap: () async {
                  if (prevDone) {
                    prevDone = false;
                    await assetsAudioPlayer!.previous();
                    prevDone = true;
                  }
                },
                child: Container(
                  color: Colors.transparent,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Icon(
                    FontAwesomeIcons.stepBackward,
                    color: widget.index != 0 ? Colors.white : Colors.grey,
                    size: 20,
                  ),
                )),
            assetsAudioPlayer!.builderIsPlaying(
              builder: (context, playing) => playing
                  ? GestureDetector(
                      onTap: () async {
                        await assetsAudioPlayer!.pause();
                      },
                      child: Container(
                        color: Colors.transparent,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Icon(FontAwesomeIcons.pause,
                            color: Colors.white, size: 20),
                      ))
                  : GestureDetector(
                      onTap: () async {
                        await assetsAudioPlayer!.play();
                      },
                      child: Container(
                        color: Colors.transparent,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Icon(FontAwesomeIcons.play,
                            color: Colors.white, size: 20),
                      )),
            ),
            GestureDetector(
                onTap: () async {
                  if (nextDone) {
                    if (widget.index != widget.last) {
                      nextDone = false;

                      await assetsAudioPlayer!.next(stopIfLast: true);
                      nextDone = true;
                    }
                  }
                },
                child: Container(
                  color: Colors.transparent,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Icon(FontAwesomeIcons.stepForward,
                      color: widget.index != widget.last
                          ? Colors.white
                          : Colors.grey,
                      size: 20),
                )),
            GestureDetector(
                onTap: () {
                  if (!shuffled!) {
                    //  widget. prefs!.setBool("shuffle", true);
                    setState(() {
                      shuffled = true;
                    });
                  } else {
                    //  widget. prefs!.setBool("shuffle", false);
                    setState(() {
                      shuffled = false;
                    });
                  }
                  assetsAudioPlayer!.toggleShuffle();
                },
                child: assetsAudioPlayer!.isShuffling.value
                    ? Container(
                        color: Colors.transparent,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Icon(FontAwesomeIcons.random,
                            color: Colors.white, size: 20),
                      )
                    : Container(
                        color: Colors.transparent,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Icon(FontAwesomeIcons.random,
                            color: Colors.grey, size: 20),
                      )),
          ],
        ),
      );
    });
  }
}
