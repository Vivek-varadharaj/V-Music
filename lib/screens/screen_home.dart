import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_music_player/data_base/audio_model.dart';
import 'package:v_music_player/data_base/database_functions.dart';
import 'package:v_music_player/style/style.dart';
import 'package:v_music_player/widgets/recent_song_tile.dart';
import 'package:v_music_player/widgets/widget_song_tile.dart';

class HomeScreen extends StatefulWidget {
  final List<Audio> audioModelSongs;
  SharedPreferences prefs;

  HomeScreen(this.audioModelSongs, this.prefs);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool? switchTileView;
  bool? notifications;

  List<AudioModel> recentSongs = [];
  num? _timerValue;
  Timer? _timer;
  int? _themeSelection;

  @override
  void initState() {
    super.initState();
    getPrefference();
  }

  void getPrefference() {
    DatabaseFunctions db = DatabaseFunctions.getDatabase();
    switchTileView = widget.prefs.getBool("tile view");
    notifications = widget.prefs.getBool("notifications");
    _themeSelection = widget.prefs.getInt("theme");

    recentSongs = db.getSongs("Recent Songs");
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        gradient: StyleForApp.bodyTheme,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: Drawer(
          child: Container(
            color: Colors.black87,
            child: Column(
              children: [
                DrawerHeader(
                  child: Text(
                    "V Music",
                    style: width < 600
                        ? StyleForApp.heading
                        : StyleForApp.headingLarge,
                  ),
                  padding: EdgeInsets.all(40),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  // color: ColorsForApp.goldenLow,
                  child: ListTile(
                    onTap: () {
                      showAboutDialog(
                          context: context,
                          applicationName: "V Music",
                          applicationVersion: "1.01",
                          applicationLegalese: "Not Attached",
                          applicationIcon: Icon(FontAwesomeIcons.appStore));
                    },
                    title: Text(
                      "About",
                      style: StyleForApp.tileDisc,
                    ),
                    leading: Icon(
                      FontAwesomeIcons.user,
                      color: Colors.white,
                      size: 18,
                    ),
                    trailing: Icon(Icons.forward, color: Colors.white),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  // color: ColorsForApp.goldenLow,
                  child: ListTile(
                    title: Text(
                      "Terms and conditions",
                      style: StyleForApp.tileDisc,
                    ),
                    leading: Icon(
                      FontAwesomeIcons.scroll,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  // color: ColorsForApp.goldenLow,
                  child: ListTile(
                    title: Text(
                      "Privacy policy",
                      style: StyleForApp.tileDisc,
                    ),
                    leading: Icon(
                      FontAwesomeIcons.appStore,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  // color: ColorsForApp.goldenLow,
                  child: ListTile(
                    title: Text(
                      "Notifications",
                      style: StyleForApp.tileDisc,
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
                        inactiveTrackColor:
                            ColorsForApp.golden.withOpacity(0.5),
                        value: notifications!,
                        onChanged: (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: value == true
                                  ? Text(
                                      "Notification will be turned ON in next restart")
                                  : Text(
                                      "Notification will be turned OFF in next restart"),
                            ),
                          );
                          setState(() {
                            notifications = value;
                            widget.prefs.setBool("notifications", value);
                          });
                        }),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  // color: ColorsForApp.goldenLow,
                  child: ListTile(
                    title: Text(
                      "Sleep Timer",
                      style: StyleForApp.tileDisc,
                    ),
                    leading: Icon(
                      FontAwesomeIcons.stopwatch,
                      color: Colors.white,
                      size: 18,
                    ),
                    trailing: DropdownButton(
                      dropdownColor: Colors.black,
                        underline: Container(),
                        iconDisabledColor: Colors.white,
                        iconEnabledColor: Colors.white,
                        hint: Text(
                          "Timer",
                          style: StyleForApp.tileDisc,
                        ),
                        value: _timerValue,
                        onChanged: (num? val) {
                          setState(() {
                            _timerValue = val!;
                          });

                          _timer = Timer(
                              Duration(minutes: _timerValue!.toInt()), () {
                            SystemNavigator.pop();
                          });
                        },
                        items: [
                          _timerValue != null
                              ? DropdownMenuItem(
                                  onTap: () {
                                    setState(() {
                                      _timer!.cancel();
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("Sleep timer is Off" ,style: StyleForApp.heading)));
                                                setState(() {
                                                  
                                                });
                                  },
                                  value: double.infinity,
                                  child: Text("Reset" , style: StyleForApp.heading,))
                              : DropdownMenuItem(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("Sleep timer is Off" ,style: StyleForApp.heading)));
                                                setState(() {
                                                  
                                                });
                                  },
                                  value: double.infinity,
                                  child: Text("Timer",style: StyleForApp.heading)),
                          DropdownMenuItem(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text("App will close after 30 mins",style: StyleForApp.heading)));
                              },
                              value: 30,
                              child: Text("30 min",style: StyleForApp.heading)),
                          DropdownMenuItem(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "App will close after 60 min",style: StyleForApp.heading)));
                              },
                              value: 60,
                              child: Text("60 min",style: StyleForApp.heading)),
                        ]),
                  ),
                ),
                Container(
                  child: ListTile(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.black,
                                title: Column(
                                  children: [
                                    ListTile(
                                      tileColor: _themeSelection==1 ? Colors.grey: Colors.transparent,
                                      onTap: ()  {
                                        setState(() {
                                          widget.prefs.setInt("theme", 1);
                                          StyleForApp.setTheme(1);
                                          getPrefference();
                                        });
                                        Navigator.of(context).pop();
                                         Navigator.of(context).pop();
                                      },
                                      title: Text("Black and White",style: StyleForApp.tileDisc),
                                    ),
                                    ListTile(
                                      tileColor: _themeSelection == 2? Colors.grey : Colors.transparent,
                                      onTap: () {
                                        setState(() {
                                          widget.prefs.setInt("theme", 2);
                                          StyleForApp.setTheme(2);
                                          getPrefference();
                                        });
                                        Navigator.of(context).pop();
                                         Navigator.of(context).pop();
                                      },
                                      title: Text("Blue and Black",style: StyleForApp.tileDisc,),
                                    ),
                                     ListTile(
                                        tileColor: _themeSelection == 3? Colors.grey : Colors.transparent,
                                      onTap: () {
                                        setState(() {
                                          widget.prefs.setInt("theme", 3);
                                          StyleForApp.setTheme(3);
                                          getPrefference();
                                        });
                                        Navigator.of(context).pop();
                                         Navigator.of(context).pop();
                                      },
                                      title: Text("Orange and Black",style: StyleForApp.tileDisc),
                                    ),
                                  ],
                                ),
                              ));
                    },
                    title: Text(
                      "Select Theme",
                      style: StyleForApp.tileDisc,
                    ),
                    leading: Icon(
                      FontAwesomeIcons.rainbow,
                      color: Colors.white,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        // backgroundColor: ColorsForApp.dark,
        appBar: AppBar(
          elevation: 0,
          // shadowColor: ColorsForApp.golden,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(
            "V Music",
            style: width < 600 ? StyleForApp.heading : StyleForApp.headingLarge,
          ),
          actions: [
            Center(
                child: Text(
              "List View",
              style: width < 600
                  ? TextStyle(color: Colors.white, fontSize: 10)
                  : StyleForApp.heading,
            )),
            Transform.scale(
              scale: width < 600 ? 0.5 : 1,
              child: Switch(
                  inactiveThumbColor: ColorsForApp.golden,
                  activeColor: ColorsForApp.golden,
                  activeTrackColor: ColorsForApp.golden,
                  inactiveTrackColor: ColorsForApp.golden.withOpacity(0.5),
                  value: switchTileView!,
                  onChanged: (value) async {
                    await widget.prefs.setBool("tile view", value);
                    setState(() {
                      getPrefference();
                    });
                  }),
            )
          ],
        ),
        body: Container(
            padding: EdgeInsets.only(
                left: 15,
                top: 10,
                right: 15,
                bottom: recentSongs.isEmpty ? 0 : 70),
            child: switchTileView!
                ? GridView.count(
                    crossAxisCount: 1,
                    childAspectRatio: 5.5,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 15,
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
                : Container(
                    padding:
                        EdgeInsets.only(bottom: recentSongs.isEmpty ? 0 : 1),
                    child: GridView.count(
                        childAspectRatio: 2 / 3.5,
                        mainAxisSpacing: 15,
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        children: [
                          ...widget.audioModelSongs
                              .map((e) => SongTile(
                                    e,
                                    widget.audioModelSongs,
                                    widget.audioModelSongs.indexOf(e),
                                  ))
                              .toList(),
                        ]),
                  )),
      ),
    );
  }

  void setStateOfTheScreen() {
    setState(() {});
  }
}
