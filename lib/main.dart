import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:v_music_player/data_base/database_functions.dart';
import 'package:v_music_player/screens/screen_home.dart';
import 'package:v_music_player/screens/screen_library.dart';
import 'package:v_music_player/screens/screen_search.dart';
import 'package:v_music_player/style/style.dart';

import 'package:v_music_player/data_base/audio_model.dart';
import 'package:v_music_player/widgets/bottom_control_other_screens.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory dir = await getApplicationDocumentsDirectory();
  String path = dir.path;
  Hive.init(path);
  Hive.registerAdapter(AudioModelAdapter());
  await Hive.openBox<List<dynamic>>("allSongsBox");
  

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 
  
  int _selectedIndex = 0;
  OnAudioQuery? audio;
  List<SongModel> songs = [];
  List<AudioModel> audioModelSongs = [];
  List<AudioModel> audioModelSongs1 = [];
  List<AudioModel> favorites=[];
  List<AudioModel> recentSongs=[];
  Box<List<dynamic>>? allSongsBox;
  List<Audio> audioSongsList = [];
  DatabaseFunctions db = DatabaseFunctions.getDatabase();

  @override
  void initState() {
    // allSongsBox = Hive.box("allSongsBox");

    super.initState();
    audio = OnAudioQuery();
    getSongs();
  }

  void getSongs() async {
    if (await Permission.storage.status.isDenied) {
      await Permission.storage.request();
    }
    songs = await audio!.querySongs();
    

    audioModelSongs = songs
        .map((songModel) => AudioModel(
              path: songModel.uri,
              album: songModel.album,
              title: songModel.title,
              id: songModel.id,
            ))
        .toList();
    db.insertSongs(audioModelSongs,"All Songs");
    audioModelSongs1 = await db.getSongs("All Songs");
    List<String> keys = db.getKeys();

    if(keys.contains("Favorites")){

    }else db.insertSongs(favorites, "Favorites");

    if(keys.contains("Recent Songs")){

    }else db.insertSongs(recentSongs, "Recent Songs");

    audioSongsList = db.AudioModelToAudio(audioModelSongs1);

    setState(() {});
  
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> bottomNavScreens = [
      HomeScreen(audioSongsList),
      SearchScreen(),
      Library(
          audioSongsList), //I have to pass the recent song here. or i will have to get the recent songs in LIbrary screen
    ];
    return Scaffold(
      
       bottomSheet:BottomControlForOtherScreens(audioSongsList),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: ColorsForApp.golden,
            blurRadius: 2,
          )
        ]),
        child: BottomNavigationBar(
          unselectedItemColor: Colors.white,
          currentIndex: _selectedIndex,
          selectedItemColor: ColorsForApp.golden,
          onTap: _onItemTapped,
          backgroundColor: ColorsForApp.dark,
          items: [
            BottomNavigationBarItem(
                backgroundColor: ColorsForApp.dark,
                icon: Icon(
                  FontAwesomeIcons.home,
                ),
                title: Text(
                  "Home",
                  style: TextStyle(color: Colors.white),
                )),
            BottomNavigationBarItem(
                backgroundColor: ColorsForApp.dark,
                icon: Icon(
                  FontAwesomeIcons.search,
                ),
                title: Text(
                  "Search",
                  style: TextStyle(color: Colors.white),
                )),
            BottomNavigationBarItem(
                backgroundColor: ColorsForApp.dark,
                icon: Icon(
                  Icons.library_music,
                ),
                title: Text(
                  "Library",
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
      ),
      body: bottomNavScreens.elementAt(_selectedIndex),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
