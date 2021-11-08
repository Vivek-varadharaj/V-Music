
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:v_music_player/screens/screen_albums.dart';

import 'package:v_music_player/screens/screen_playlist.dart';
import 'package:v_music_player/style/style.dart';

class MenuTile extends StatelessWidget {
  
  MenuTile(this.title);
 final String title;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(title=="Playlists"){
 Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: PlayListScreen(title)));//Actually we will be passing the entire song list model here
        }
        else if(title=="Albums"){
           Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: AlbumScreen()));//Actually we will be passing the entire song list model here
        }
       
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:8.0,vertical:8),
        child: Container(
          
          height: 80,
          padding:EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.black,
            boxShadow: [BoxShadow(
              color: ColorsForApp.golden,
              blurRadius: 2,
            )]
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal:25.0),
                    child: Text(title,style: StyleForApp.heading,),
                  )),
                Icon(FontAwesomeIcons.arrowAltCircleRight,color: Colors.white,)
            ],
             
           
          ),
        ),
      ),
    );
  }
}