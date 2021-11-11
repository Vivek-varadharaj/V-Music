import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';
import 'package:v_music_player/data_base/audio_model.dart';
import 'package:v_music_player/data_base/database_functions.dart';
import 'package:v_music_player/screens/screen_playlist_songs.dart';
import 'package:v_music_player/style/style.dart';

// ignore: must_be_immutable
class PlaylistTile extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  DatabaseFunctions db = DatabaseFunctions.getDatabase();
  
  final Box<List<dynamic>>? allSongsBox = Hive.box("allSongsBox");
  final Function setStateOfPlaylistScreen;
  PlaylistTile(this.title, this.setStateOfPlaylistScreen);
   
  final String title;
  @override
  Widget build(BuildContext context) {
    controller.text=title;
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
        if (title != "Favorites" &&
            title != "All Songs" &&
            title != "Recent Songs") {
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
                    child: (title == "Favorites" ||
                                title == "All Songs" ||
                                title == "Favorites") ||
                            title == "Recent Songs"
                        ? Icon(
                            FontAwesomeIcons.arrowAltCircleRight,
                            color: Colors.white,
                          )
                        : Container()),
              ),
              title != "All Songs" &&
                      title != "Favorites" &&
                      title != "Recent Songs"
                  ? Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(context: context, builder: (context)=>
                            AlertDialog(
                              backgroundColor: ColorsForApp.goldenLow,
                              actionsAlignment: MainAxisAlignment.center,
                              title: TextFormField(
                                cursorColor: Colors.black,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    
                    focusedBorder:OutlineInputBorder(
                          borderSide: BorderSide(
                    color: ColorsForApp.golden.withOpacity(0.5),
                  ),) ,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                    color: ColorsForApp.golden.withOpacity(0.5),
                  ),),),
                                controller: controller,
                                onChanged: (value){
                                 
                                },
                                
                              ),
                              actions: [
                                ElevatedButton(onPressed: (){
                                  List<AudioModel> audioModelSongs = db.getSongs(title);
                                  if(controller.text!=""){
                                    db.deleteKey(title);
                                     db.insertSongs(audioModelSongs, controller.text);
                                  
                                  setStateOfPlaylistScreen();
                                  Navigator.of(context).pop();
                                  }else{
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Playlist name can't be empty")));
                                  }
                                 
                                }, child: Text("Confirm"),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.black
                                ),
                                )
                              ],
                            )
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: Container(
                                child: Icon(
                              FontAwesomeIcons.edit,
                              color: Colors.white,
                              size: 20,
                            )),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  actionsAlignment: MainAxisAlignment.spaceAround,
                                      backgroundColor: ColorsForApp.goldenLow,
                                      title: Text("Delete?"),
                                      actions: [
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: ColorsForApp.dark,
                                            ),
                                            onPressed: () {
                                              allSongsBox!.delete(title);
                                              setStateOfPlaylistScreen();
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Yes")),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: ColorsForApp.dark,
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("No"))
                                      ],
                                    ));
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Container(
                                child: Icon(
                              FontAwesomeIcons.trash,
                              color: Colors.white,
                              size: 20,
                            )),
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
