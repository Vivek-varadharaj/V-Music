import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:v_music_player/data_base/audio_model.dart';
import 'package:v_music_player/data_base/database_functions.dart';
import 'package:v_music_player/style/style.dart';
import 'package:v_music_player/widgets/app_bar.dart';
import 'package:v_music_player/widgets/recent_song_tile.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({ Key? key }) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseFunctions db = DatabaseFunctions.getDatabase();
  List <Audio> audioSongs =[];
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsForApp.dark,
      appBar: CustomAppBar.customAppBar("Search"),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 8),
            child: TextField(
              controller: _controller,
              style: StyleForApp.tileDisc,
              decoration: InputDecoration(
                labelText: "Search",
                labelStyle: StyleForApp.tileDisc,
               suffixIcon: Icon(FontAwesomeIcons.search,color: ColorsForApp.golden.withOpacity(0.5),),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorsForApp.golden.withOpacity(0.5),
                  width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorsForApp.golden.withOpacity(0.5),
                  width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorsForApp.golden.withOpacity(0.5),
                  width: 1),
              ),
            ),
            onChanged: (keyword) async{
             
             List<AudioModel>  myAudioModelSongs=  db.getSongs("All Songs");
             audioSongs = db.AudioModelToAudio(myAudioModelSongs);
             audioSongs = await Future.delayed(Duration(milliseconds: 1000),(){
               print(keyword.toUpperCase());
             return  audioSongs.where((element) => element.metas.title!.toUpperCase().startsWith(keyword.toUpperCase())).toList();
             });
             setState(() {
               if(keyword==""){
                 audioSongs = [];
               }
               else Timer.periodic(Duration(milliseconds: 1000),(timer){
                  audioSongs = audioSongs;
               }) ;
               
             });
            },
            ),
          ),

         ...audioSongs.map((audioSong) => RecentSongTile(audioModel: audioSong, audioModelSongs: audioSongs,index: audioSongs.indexOf(audioSong),) )
        ],
      ),
    );
  }
}