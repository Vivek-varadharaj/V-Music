import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_music_player/audio_player/player.dart';
import 'package:v_music_player/style/style.dart';

class BottomControlPannel extends StatefulWidget {
  int index;
  BottomControlPannel(this.index);
  @override
  _BottomControlPannelState createState() => _BottomControlPannelState();
}

class _BottomControlPannelState extends State<BottomControlPannel> {
  bool shuffled = false;
  bool looped = false;
  SharedPreferences? prefs;
  void getModePreference() async {
    prefs = await SharedPreferences.getInstance();
    looped = prefs!.getBool("loop")!;
    shuffled = prefs!.getBool("shuffle")!;
  }

  Player player = Player();

  AssetsAudioPlayer? assetsAudioPlayer;
  @override
  void initState() {
    super.initState();
    getModePreference();
    assetsAudioPlayer = player.getAssetsAudio();
  }

  Timer? _timer;
  @override
  Widget build(BuildContext context) {
    return assetsAudioPlayer!.builderCurrent(
        builder: (context, currentPlaying) {
      return Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: ColorsForApp.golden,
                blurRadius: 2,
              )
            ],
            color: ColorsForApp.dark,
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
                  if (!looped) {
                    assetsAudioPlayer!.setLoopMode(LoopMode.single);
                    prefs!.setBool("loop", true);
                    setState(() {
                      getModePreference();
                    });
                  } else {
                    assetsAudioPlayer!.setLoopMode(LoopMode.playlist);
                    prefs!.setBool("loop", false);
                    setState(() {
                      getModePreference();
                    });
                  }
                },
                child: looped
                    ? Icon(
                        Icons.repeat_one,
                        color: Colors.white,
                      )
                    : Icon(
                        Icons.repeat_one,
                        color: Colors.grey,
                      )),
            GestureDetector(
                onTap: () async {
                  if (_timer != null) {
                   
                    _timer!.cancel();
                  }

                  _timer = Timer(Duration(milliseconds: 200), () {
                    if(widget.index!=0)
                    assetsAudioPlayer!.previous();
                    else (){};
                  });
                },
                child: Icon(
                  FontAwesomeIcons.stepBackward,
                  color: widget.index != 0 ? Colors.white : Colors.grey,
                  size: 20,
                )),
            assetsAudioPlayer!.builderIsPlaying(
              builder: (context, playing) => playing
                  ? GestureDetector(
                      onTap: () async {
                        await assetsAudioPlayer!.pause();
                      },
                      child: Icon(FontAwesomeIcons.pause,
                          color: Colors.white, size: 20))
                  : GestureDetector(
                      onTap: () async {
                        await assetsAudioPlayer!.play();
                      },
                      child: Icon(FontAwesomeIcons.play,
                          color: Colors.white, size: 20)),
            ),
            GestureDetector(
                onTap: () async {
                  if (_timer != null) {
                   
                    _timer!.cancel();
                  }

                  _timer = Timer(Duration(milliseconds: 200), () {
                    assetsAudioPlayer!.next();
                  });
                },
                child: Icon(FontAwesomeIcons.stepForward,
                    color: Colors.white, size: 20)),
            GestureDetector(
                onTap: () {
                  if (!shuffled) {
                    prefs!.setBool("shuffle", true);
                    setState(() {
                      getModePreference();
                    });
                  } else {
                    prefs!.setBool("shuffle", false);
                    setState(() {
                      getModePreference();
                    });
                  }
                assetsAudioPlayer!.toggleShuffle();
                },
                child: shuffled
                    ? Icon(FontAwesomeIcons.random,
                        color: Colors.white, size: 20)
                    : Icon(FontAwesomeIcons.random,
                        color: Colors.grey, size: 20)),
          ],
        ),
      );
    });
  }
}
