// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';

import 'package:v_music_player/data_base/audio_model.dart';
import 'package:v_music_player/data_base/database_functions.dart';

import 'package:v_music_player/style/style.dart';

class AddToPlaylistTile extends StatelessWidget {
  final Box<List<dynamic>>? allSongsBox = Hive.box("allSongsBox");
  final DatabaseFunctions db = DatabaseFunctions.getDatabase();
  List<AudioModel>? playlistSongs = [];
  final Audio? audioModel;
  AudioModel? myAudioModelSong;
  final String playlistName;
  AddToPlaylistTile(this.audioModel, this.playlistName);
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        {
          if (_timer != null) {
            _timer!.cancel();
          }
          _timer = Timer(Duration(milliseconds: 300), () {
            db.addToPlaylist(
                audioModel: audioModel,
                playlistName: playlistName,
                context: context);
          });
        }
        ;
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
        child: Container(
          height: 60,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  color: ColorsForApp.golden,
                  blurRadius: 2,
                )
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      playlistName,
                      style: StyleForApp.heading,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Container(
                    child: (playlistName != "Favorites")
                        ? Icon(
                            FontAwesomeIcons.arrowAltCircleRight,
                            color: Colors.white,
                          )
                        : Icon(
                            Icons.favorite_border_rounded,
                            color: Colors.red,
                          )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getPlaylist(context) async {
    myAudioModelSong = AudioModel(
        path: audioModel!.path,
        album: audioModel!.metas.album,
        title: audioModel!.metas.title,
        id: audioModel!.metas.extra!["id"],
        duration: audioModel!.metas.extra!["duration"]);
    playlistSongs = await db.getSongs(playlistName);

    if (isExists()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Song already exists"),
      ));
    } else {
      playlistSongs!.add(AudioModel(
          path: audioModel!.path,
          album: audioModel!.metas.album,
          title: audioModel!.metas.title,
          id: audioModel!.metas.extra!["id"],
          duration: audioModel!.metas.extra!["duration"]));
      await allSongsBox!.put(playlistName, playlistSongs!);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Song added to the playlist"),
      ));
      Navigator.of(context).pop();
    }
  }

  bool isExists() {
    if (playlistSongs!.length != 0) {
      final List<AudioModel> songs = playlistSongs!
          .where((element) => element.id == myAudioModelSong!.id)
          .toList();
      if (songs.length == 0) {
        return false;
      } else
        return true;
    } else
      return false;
  }
}
