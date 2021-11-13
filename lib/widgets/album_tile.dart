import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:v_music_player/screens/screen_album_songs.dart';

import 'package:v_music_player/style/style.dart';

class AlbumTile extends StatelessWidget {
 final String albumName;
 final int noOfSongs;
 final int index;
 final List<Color> shufflingColors=StyleForApp.darkColors;
  AlbumTile(this.albumName, this.noOfSongs, this.index);
  void shufflingTheColors(){
    if (index>= StyleForApp.darkColors.length && index<StyleForApp.darkColors.length*2 && index % 2 ==0  ){
     shufflingColors.shuffle();
     shufflingColors.shuffle();
     
          
    }
     else if (index>= StyleForApp.darkColors.length && index<StyleForApp.darkColors.length*2 && index % 2 !=0  ){
     shufflingColors.shuffle();
     
     
          
    }
    
    else if(index>=StyleForApp.darkColors.length*2){
      shufflingColors.shuffle();
    }
  }

  @override
  Widget build(BuildContext context) {
    shufflingTheColors();
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: AlbumSongsScreen(albumName),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: ColorsForApp.golden,
                blurRadius: 2,
              ),
            ],
            color: index<StyleForApp.darkColors.length ? StyleForApp.darkColors[index] : shufflingColors[0],
          ),
          height: 100,
          width: 100,
          child: Center(
              child: Text(
            albumName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ColorsForApp.golden,
             
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            maxLines: 2,
          )),
        ),
      ),
    );
  }
}
