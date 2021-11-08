import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';
import 'package:v_music_player/screens/screen_playlist_songs.dart';
import 'package:v_music_player/style/style.dart';

class PlaylistTile extends StatelessWidget {
  final Box<List<dynamic>>? allSongsBox = Hive.box("allSongsBox");
  final Function setStateOfPlaylistScreen;
  PlaylistTile(this.title, this.setStateOfPlaylistScreen);
 final String title;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child: PlaylistSongsScreen(
                    title))); //Actually we will be passing the entire song list model here
      },
      onLongPress: () {
        if (title != "Favorites" && title != "All Songs" && title != "Recent Songs") {
          allSongsBox!.delete(title);
          setStateOfPlaylistScreen();
          print("Deleted Playlist");
        } else
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Cannot delete in-built playlist '$title'"),
            ),
          );
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
                      title,
                      style: StyleForApp.heading,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Container(
                    child: (title != "Favorites")
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
}
