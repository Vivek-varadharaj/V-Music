import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:v_music_player/style/style.dart';

class BottomControlPannel extends StatefulWidget {
  const BottomControlPannel({ Key? key }) : super(key: key);

  @override
  _BottomControlPannelState createState() => _BottomControlPannelState();
}

class _BottomControlPannelState extends State<BottomControlPannel> {
  AssetsAudioPlayer assetsAudioPlayer =AssetsAudioPlayer.withId("0");
  @override
  Widget build(BuildContext context) {
    return assetsAudioPlayer.builderIsPlaying(builder: (context, isPlaying){
      return  Container(
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(
                      color: ColorsForApp.golden,
                      blurRadius: 2,
                    )],
                    color: ColorsForApp.dark,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),)
                  ),
                  
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  height: MediaQuery.of(context).size.height*0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(child: Icon(FontAwesomeIcons.random,color: Colors.white,)),
                      GestureDetector(
                        onTap: (){
                          assetsAudioPlayer.previous();
                        },
                        child: Icon(FontAwesomeIcons.stepBackward,color: Colors.white,)),
                     isPlaying ? GestureDetector(
                       onTap: (){
                         assetsAudioPlayer.pause();
                       },
                       child: Icon(FontAwesomeIcons.stop,color: Colors.white,)) : GestureDetector(
                         onTap: (){
                           assetsAudioPlayer.play();
                         },
                         child: Icon(FontAwesomeIcons.play,color: Colors.white,)),
                       GestureDetector(
                         onTap: (){
                           assetsAudioPlayer.next();
                         },
                         child: Icon(FontAwesomeIcons.stepForward,color: Colors.white,)),
                      Icon(FontAwesomeIcons.random,color: Colors.white,),
                    ],
                  ),
                );
    });
  }
}