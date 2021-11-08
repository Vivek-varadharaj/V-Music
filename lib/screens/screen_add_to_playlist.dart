import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:v_music_player/widgets/add_to_playlist_tile.dart';
import 'package:v_music_player/widgets/app_bar.dart';

class AddToPlaylistScreen extends StatefulWidget {
 final Audio? audioModel;
  AddToPlaylistScreen(this.audioModel);

  @override
  State<AddToPlaylistScreen> createState() => _AddToPlaylistScreenState();
}

class _AddToPlaylistScreenState extends State<AddToPlaylistScreen> {
  final Box<List<dynamic>> allSongsBox = Hive.box("allSongsBox");

  List<String>? playlistNames=[];

 void getPlaylistNames() async {
    playlistNames = await allSongsBox.keys.toList().cast<String>();
    playlistNames =
        playlistNames!.where((element) => element != "Favorites").toList();
    print(playlistNames);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getPlaylistNames();
    
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: CustomAppBar.customAppBar("Add to playlist"),
      body: ListView(
        children: [
          ...playlistNames!.map((playlistNames) => AddToPlaylistTile(widget.audioModel, playlistNames)).toList()
        ],
      ),
    );
  }
}
