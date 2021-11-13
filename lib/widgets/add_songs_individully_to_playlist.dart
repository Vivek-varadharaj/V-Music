

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:v_music_player/screens/screen_adding_individual_songs_to_playlist.dart';

import 'package:v_music_player/style/style.dart';

class AddIndividulSongsToPlaylist extends StatelessWidget {
 final Function setStateOfScreen;
 final String playlistName;
   AddIndividulSongsToPlaylist(this.setStateOfScreen,this.playlistName);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: (){
          Navigator.push(
            context,
            PageTransition(
                duration: Duration(milliseconds: 500),
                type: PageTransitionType.fade,
                child: ScreenAddingIndividualSongsToPlaylist(setStateOfScreen,playlistName)));
      },
      child: Container(
       
        height: width< 600 ?  60 : 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Text(
              "Add or Remove Songs ",
              style:width < 600 ? StyleForApp.tileDisc : StyleForApp.tileDiscLarge,
            ) ,
            Icon(
              Icons.add,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}