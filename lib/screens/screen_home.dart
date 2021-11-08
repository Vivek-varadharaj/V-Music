import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:v_music_player/style/style.dart';

import 'package:v_music_player/widgets/recent_song_tile.dart';
import 'package:v_music_player/widgets/widget_song_tile.dart';



class HomeScreen extends StatefulWidget {
 final List<Audio> audioModelSongs;
  HomeScreen(this.audioModelSongs);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool switchTileView = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       drawer: Drawer(
        child: Container(
          color: ColorsForApp.dark,
          child: Column(
            children: [
            DrawerHeader(child: Text("V Music", style:StyleForApp.heading ,))  ,
              ListTile(
                title: Text("About",style: StyleForApp.heading,),
              )
            ],
          ),
        ),
      ),
      backgroundColor: ColorsForApp.dark,
      appBar: AppBar(
        elevation: 2,
        shadowColor: ColorsForApp.golden,
        centerTitle: true,
        backgroundColor: ColorsForApp.light,
        title: Text(
          "V Music",
          style: StyleForApp.heading,
        ),
        actions: [
          Center(
              child: Text(
            "List View",
            style: TextStyle(color: Colors.white, fontSize: 10),
          )),
          Transform.scale(
            scale: 0.5,
            child: Switch(
                materialTapTargetSize: MaterialTapTargetSize.padded,
                inactiveThumbColor: ColorsForApp.golden,
                activeColor: ColorsForApp.golden,
                activeTrackColor: ColorsForApp.golden,
                inactiveTrackColor: ColorsForApp.golden.withOpacity(0.5),
                value: switchTileView,
                onChanged: (value) {
                  setState(() {
                    switchTileView = value;
                  });
                }),
          )
        ],
      ),
      body: Container(
          // color: Colors.grey[200],
          padding: const EdgeInsets.only(left: 15, top: 10, right: 15),
          child: switchTileView
              ? GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: 5.5,
                  mainAxisSpacing: 8,
                  children: [
                    ...widget.audioModelSongs
                        .map(
                          (e) => RecentSongTile(
                           audioModel: e,
                          audioModelSongs:  widget.audioModelSongs,
                           index: widget.audioModelSongs.indexOf(e),
                          ),
                        )
                        .toList(),
                    Container(),
                  ],
                )
              : GridView.count(
                  childAspectRatio: 2 / 3.5,
                  mainAxisSpacing: 15,
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  children: widget.audioModelSongs
                      .map((e) => SongTile(e, widget.audioModelSongs,
                          widget.audioModelSongs.indexOf(e)))
                      .toList())),
    );
  }
}
