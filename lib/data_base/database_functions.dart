import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:page_transition/page_transition.dart';
import 'package:v_music_player/screens/screen_add_to_playlist.dart';
import 'package:v_music_player/style/style.dart';

import 'audio_model.dart';

class DatabaseFunctions {
  final Box<List<dynamic>>? allSongsBox = Hive.box("allSongsBox");
  static DatabaseFunctions? db;
  DatabaseFunctions.getDatabase();

  factory DatabaseFunctions() {
    if (db == null) {
      db = DatabaseFunctions.getDatabase();
      return db!;
    }
    return db!;
  }

  // get songs by playlist name

  Future<List<AudioModel>> getSongs(playlistName) async {
    final List<AudioModel> audioModelSongs =
        await allSongsBox!.get(playlistName)!.cast<AudioModel>();
    return audioModelSongs;
  }

  // insert songs by playlist name

  void insertSongs(List<AudioModel> playlist, String playlistName) async {
    await allSongsBox!.put(playlistName, playlist);
  }

  // converting Audio Model into Audio
  List<Audio> AudioModelToAudio(List<AudioModel> audioModelSongs) {
    List<Audio> audioSongs = audioModelSongs
        .map(
          (audioModel) => Audio.file(
            audioModel.path!,
            metas:
                Metas(album: audioModel.album, title: audioModel.title, extra: {
              "image": Container(
                width: 100,
                height: 100,
                child: QueryArtworkWidget(
                  artworkBorder: BorderRadius.circular(2),
                  type: ArtworkType.AUDIO,
                  id: audioModel.id!,
                  nullArtworkWidget: Container(
                    color: Colors.blue,
                    child: Image.asset(
                      "assets/asset_image_2.jpeg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              "id": audioModel.id,
            }),
          ),
        )
        .toList();

    return audioSongs;
  }
// converting audio to myAudioModel

  List<AudioModel> audioToMyAudioModel(List<Audio> audioModelSongs) {
    return audioModelSongs
        .map((audioModel) => AudioModel(
            path: audioModel.path,
            album: audioModel.metas.album,
            title: audioModel.metas.title,
            id: audioModel.metas.extra!["id"]))
        .toList();
  }

  // fetching all the keys

  List<String> getKeys() {
    final List<String> keys = allSongsBox!.keys.toList().cast<String>();
    return keys;
  }

  // This is a function to add song to playlist and showing a snackbar confirmation

  void addToPlaylist(
      {Audio? audioModel, String? playlistName, BuildContext? context}) async {
    final DatabaseFunctions dbl = DatabaseFunctions.getDatabase();

    //converting Audio into AudioModel inorder to add to the playlist

    AudioModel myAudioModelSong = AudioModel(
        path: audioModel!.path,
        album: audioModel.metas.album,
        title: audioModel.metas.title,
        id: audioModel.metas.extra!["id"]);

    // getting all songs in the playlist from database

    List<AudioModel> playlistSongs = await dbl.getSongs(playlistName);

    // checks the adding song is currently in the playlist or not if exists we dont add else we add.

    if (isExists(playlistSongs, myAudioModelSong)) {
      // confirms the playlist name is not Recent Songs to avoid showing snackbar
      // for adding every song that ever played

      if (playlistName != "Recent Songs") {
        ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
          content: Text("Song already exists"),
        ));

        // confirms the playlist name is Recent Songs and deletes the old entry and adds the
        // new entry.

      } else if (playlistName == "Recent Songs") {
        playlistSongs
            .removeWhere((element) => element.id == myAudioModelSong.id);
            playlistSongs.add(myAudioModelSong);
        await allSongsBox!.put(playlistName, playlistSongs);
        
      }

      //  if song is not existent in playlist we simply add the song to list
      // and replace the list in database with current list
    } else {
      playlistSongs.add(AudioModel(
          path: audioModel.path,
          album: audioModel.metas.album,
          title: audioModel.metas.title,
          id: audioModel.metas.extra!["id"]));
      await allSongsBox!.put(playlistName, playlistSongs);

      // confirms the playlist name is not Recent Songs so that we can avoid
      // showing snackbar to every song added to the Recent songs
      //
      if (playlistName != "Recent Songs") {
        ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
          content: Text("Song added to '$playlistName'"),
        ));
      }

      // avoids the screen popping issue when we add song to favorites from the
      // playing screen as welll as when adding song to Recent songs from now playing screen

      if (playlistName != "Favorites" && playlistName != "Recent Songs") {
        Navigator.of(context!).pop();
      }
    }

    print(await allSongsBox!.get(playlistName));
  }

  bool isExists(playlistSongs, myAudioModelSong) {
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

  // show dialogue function for adding to playlist and favorites
  // this shows a dialog box when user taps on the elipsis icon
  // it gives two options add to playlist and add to favorites
  // when pressed on either options we call add to playlist function

  void addToPlaylistOrFavorites({BuildContext? context, Audio? audioModel}) {
    showDialog(
        context: context!,
        builder: (context) => AlertDialog(
              titlePadding: EdgeInsets.all(8),
              backgroundColor: ColorsForApp.goldenLow,
              title: Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.of(context).pop();

                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: AddToPlaylistScreen(audioModel)));
                    },
                    title: Text(
                      "Add to playlist",
                      style: StyleForApp.tileDisc,
                    ),
                    trailing: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      addToPlaylist(
                          context: context,
                          playlistName: "Favorites",
                          audioModel: audioModel);
                    },
                    title: Text(
                      "Add to Favorites",
                      style: StyleForApp.tileDisc,
                    ),
                    trailing: Icon(
                      FontAwesomeIcons.heart,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ));
    print("show dialogue");
  }
   
   void deleteFromPlaylist(List<Audio> audioModelSongs, Audio audioModel, String playlistName) {
    List<AudioModel> myAudioModelSongs =
        audioToMyAudioModel(audioModelSongs);
    myAudioModelSongs
        .removeWhere((element) => element.id == audioModel.metas.extra!['id']);
    insertSongs(myAudioModelSongs, playlistName);
    
    
  }

}