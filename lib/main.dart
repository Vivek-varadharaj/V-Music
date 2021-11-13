import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_music_player/audio_player/player.dart';
import 'package:v_music_player/data_base/database_functions.dart';
import 'package:v_music_player/screens/screen_home.dart';
import 'package:v_music_player/screens/screen_library.dart';
import 'package:v_music_player/screens/screen_search.dart';
import 'package:v_music_player/style/style.dart';
import 'package:v_music_player/data_base/audio_model.dart';
import 'package:v_music_player/widgets/bottom_control_other_screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  Directory dir = await getApplicationDocumentsDirectory();
  SharedPreferences? prefs = await SharedPreferences.getInstance();
  String path = dir.path;
  bool? notifications;
  Hive.init(path);
  Hive.registerAdapter(AudioModelAdapter());
  await Hive.openBox<List<dynamic>>("allSongsBox");
  DatabaseFunctions db = DatabaseFunctions.getDatabase();
  List<dynamic> keys = db.getKeys();
  Player player = Player.getAudioPlayer();
  if (keys.isEmpty) {
    await prefs.setBool("notifications", true);
    await prefs.setBool("loop", false);
    await prefs.setBool("shuffle", false);
    await prefs.setBool("tile view", false);
    await prefs.setInt("duration", 0);
    notifications = prefs.getBool("notifications");
  } else if (keys.contains("Recent Songs")) {
    List<AudioModel> recentSongs = db.getSongs("Recent Songs");
    if (recentSongs.length > 0) {
      recentSongs = recentSongs.reversed.toList();
      List<Audio> recentSongsToPlay = db.AudioModelToAudio(recentSongs);
      player.openPlaylistInPlayerRecent(
        index: 0,
        audioModelSongs: recentSongsToPlay,
        playlistName: "Recent Songs",
        setStateOfTheScreen: () {},
      );
    }
  }

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(prefs),
  ));
}

class MyApp extends StatefulWidget {
  SharedPreferences prefs;

  MyApp(this.prefs);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? notifications;
  int _selectedIndex = 0;
  OnAudioQuery? audio;
  List<SongModel> songs = [];
  List<AudioModel> audioModelSongs = [];
  List<AudioModel> audioModelSongs1 = [];
  List<AudioModel> favorites = [];
  List<AudioModel> recentSongs = [];
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
    print(songs[0].uri);

    audioModelSongs = songs
        .map((songModel) => AudioModel(
              path: songModel.uri,
              album: songModel.album,
              title: songModel.title,
              id: songModel.id,
              duration: songModel.duration,
            ))
        .toList();
    db.insertSongs(audioModelSongs, "All Songs");
    audioModelSongs1 = db.getSongs("All Songs");
    List<String> keys = db.getKeys();

    if (keys.contains("Favorites")) {
    } else
      db.insertSongs(favorites, "Favorites");

    if (keys.contains("Recent Songs")) {
    } else
      db.insertSongs(recentSongs, "Recent Songs");

    audioSongsList = db.AudioModelToAudio(audioModelSongs1);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    List<Widget> bottomNavScreens = [
      HomeScreen(audioSongsList, widget.prefs),
      SearchScreen(),
      Library(),
    ];

    return WillPopScope(
      onWillPop: () async {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  elevation: 20,
                  backgroundColor: ColorsForApp.goldenLow,
                  title: Text("Exit ?"),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: ColorsForApp.dark),
                          onPressed: () {
                            SystemNavigator.pop();
                          },
                          child: Text("Yes")),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: ColorsForApp.dark),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("No")),
                    ],
                  ),
                ));
        return true;
      },
      child: Scaffold(
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
                    size: width < 600 ? 18 : 32,
                  ),
                  title: Text(
                    "Home",
                    style:
                        width < 600 ? StyleForApp.heading : StyleForApp.headingLarge,
                  )),
              BottomNavigationBarItem(
                  backgroundColor: ColorsForApp.dark,
                  icon: Icon(
                    FontAwesomeIcons.search,
                    size: width < 600 ? 18 : 32,
                  ),
                  title: Text(
                    "Search",
                    style:
                        width < 600 ? StyleForApp.heading : StyleForApp.headingLarge,
                  )),
              BottomNavigationBarItem(
                  backgroundColor: ColorsForApp.dark,
                  icon: Icon(
                    Icons.library_music,
                    size: width < 600 ? 18 : 32,
                  ),
                  title: Text(
                    "Library",
                    style:
                        width < 600 ? StyleForApp.heading : StyleForApp.headingLarge,
                  )),
            ],
          ),
        ),
        body: Stack(children: [
          bottomNavScreens.elementAt(_selectedIndex),
          Positioned(
              right: 0,
              bottom: 0,
              child: BottomControlForOtherScreens(audioSongsList)),
        ]),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
