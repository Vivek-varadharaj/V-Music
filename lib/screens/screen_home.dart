import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_music_player/style/style.dart';

import 'package:v_music_player/widgets/recent_song_tile.dart';
import 'package:v_music_player/widgets/widget_song_tile.dart';

class HomeScreen extends StatefulWidget {
  final List<Audio> audioModelSongs;

  HomeScreen(
    this.audioModelSongs,
  );

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool switchTileView = false;
  bool notifications = true;
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    getPreference();
  }

  void getPreference() async {
    prefs = await SharedPreferences.getInstance();
    notifications = prefs!.getBool("notifications")!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: ColorsForApp.goldenLow,
          child: Column(
            children: [
              DrawerHeader(
                child: Text(
                  "V Music",
                  style: StyleForApp.heading,
                ),
                padding: EdgeInsets.all(40),
              ),
              ListTile(
                onTap: (){
                  showAboutDialog(context: context,applicationName: "V Music", applicationVersion: "1.01",applicationLegalese:"Not Attached",applicationIcon: Icon(FontAwesomeIcons.appStore) );
                },
                tileColor: ColorsForApp.goldenLow,
                title: Text(
                  "About",
                  style: StyleForApp.heading,
                ),
                leading: Icon(
                  FontAwesomeIcons.user,
                  color: Colors.white,
                  size: 18,
                ),
                trailing: Icon(Icons.forward, color: Colors.white),
              ),
              ListTile(
                title: Text(
                  "App Version   1.01",
                  style: StyleForApp.heading,
                ),
                leading: Icon(
                  FontAwesomeIcons.appStore,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              ListTile(
                title: Text(
                  "Notifications",
                  style: StyleForApp.heading,
                ),
                leading: Icon(
                  FontAwesomeIcons.bell,
                  color: Colors.white,
                  size: 18,
                ),
                trailing: Switch(
                    inactiveThumbColor: ColorsForApp.golden,
                    activeColor: ColorsForApp.golden,
                    activeTrackColor: ColorsForApp.golden,
                    inactiveTrackColor: ColorsForApp.golden.withOpacity(0.5),
                    value: notifications,
                    onChanged: (value) {
                      ;
                      setState(() {
                        notifications = value;
                        prefs!.setBool("notifications", value);
                      });
                    }),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: ColorsForApp.dark,
      appBar: AppBar(
        elevation: 2,
        shadowColor: ColorsForApp.golden,
        centerTitle: true,
        backgroundColor: ColorsForApp.light,
        title: Text(
          "V Music",
          style: StyleForApp.heading,
        ),
        actions: [
          Center(
              child: Text(
            "List View",
            style: TextStyle(color: Colors.white, fontSize: 10),
          )),
          Transform.scale(
            scale: 0.5,
            child: Switch(
                inactiveThumbColor: ColorsForApp.golden,
                activeColor: ColorsForApp.golden,
                activeTrackColor: ColorsForApp.golden,
                inactiveTrackColor: ColorsForApp.golden.withOpacity(0.5),
                value: switchTileView,
                onChanged: (value) {
                  setState(() {
                    switchTileView = value;
                  });
                }),
          )
        ],
      ),
      body: Container(
          // color: Colors.grey[200],
          padding: const EdgeInsets.only(left: 15, top: 10, right: 15),
          child: switchTileView
              ? GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: 5.5,
                  mainAxisSpacing: 8,
                  children: [
                    ...widget.audioModelSongs
                        .map(
                          (e) => RecentSongTile(
                            audioModel: e,
                            audioModelSongs: widget.audioModelSongs,
                            index: widget.audioModelSongs.indexOf(e),
                            playlistName: "All Songs",
                            setStateOfTheScreen: setStateOfTheScreen,
                          ),
                        )
                        .toList(),
                    Container(),
                  ],
                )
              : GridView.count(
                  childAspectRatio: 2 / 3.5,
                  mainAxisSpacing: 15,
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  children: widget.audioModelSongs
                      .map((e) => SongTile(
                            e,
                            widget.audioModelSongs,
                            widget.audioModelSongs.indexOf(e),
                          ))
                      .toList())),
    );
  }

  void setStateOfTheScreen() {
    setState(() {});
  }
}
