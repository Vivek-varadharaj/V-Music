import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:v_music_player/data_base/database_functions.dart';
import 'package:v_music_player/style/style.dart';
import 'package:v_music_player/widgets/album_tile.dart';
import 'package:v_music_player/widgets/app_bar.dart';

class AlbumScreen extends StatefulWidget {
  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  OnAudioQuery audio = OnAudioQuery();
  DatabaseFunctions db = DatabaseFunctions.getDatabase();

  List<AlbumModel>? albums = [];

  void getAlbumModels() async {
    albums = await audio.queryAlbums();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAlbumModels();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
     
      child: Scaffold(
        // backgroundColor: Colors.black,
        appBar: CustomAppBar.customAppBar("Albums", context),
        body: Container(
           decoration: BoxDecoration(
              gradient: StyleForApp.bodyTheme,
            ),
          padding: const EdgeInsets.all(15.0),
          child: GridView.count(
            crossAxisCount: 2,
            children: [
              ...albums!
                  .map(
                      (e) => AlbumTile(e.album, e.numOfSongs, albums!.indexOf(e)))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
