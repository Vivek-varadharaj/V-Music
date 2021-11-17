
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:v_music_player/screens/screen_albums.dart';

import 'package:v_music_player/screens/screen_playlist.dart';
import 'package:v_music_player/screens/screen_playlist_songs.dart';
import 'package:v_music_player/style/style.dart';

class MenuTile extends StatelessWidget {
  
  MenuTile(this.title);
 final String title;
 String? image;
  @override
  Widget build(BuildContext context) {
   if( title == "Playlists" ){
     image = "assets/playlist_image.jfif";
   }else if(title == "Albums"){
     image = "assets/album_image_1.png";
   }else {
     image = "assets/favorite.jpg";
   }
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: (){
        if(title=="Playlists"){
 Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: PlayListScreen(title)));//Actually we will be passing the entire song list model here
        }
        else if(title=="Albums"){
           Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: AlbumScreen()));//Actually we will be passing the entire song list model here
        }
        else if(title=="Favorites"){
           Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: PlaylistSongsScreen("Favorites")));
        }
       
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:8.0,vertical:8),
        child: Container(
          
          height: 80,
          padding:EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            // color: Colors.black,
           
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(image!),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal:25.0),
                    child: Text(title,style: width<600 ? StyleForApp.heading : StyleForApp.headingLarge,),
                  )),
               title !="Favorites" ? Icon(FontAwesomeIcons.arrowAltCircleRight,color: Colors.white,size: width<600 ? 22:32,
               
               ): Icon(FontAwesomeIcons.heart,color: Colors.red,size: width<600 ? 22:32,)
            ],
             
           
          ),
        ),
      ),
    );
  }
}