import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:v_music_player/data_base/audio_model.dart';
import 'package:v_music_player/style/style.dart';

class CreatePlaylist extends StatefulWidget {
final  Function setStateOfPlaylistScreen;
  CreatePlaylist(this.setStateOfPlaylistScreen);
 static AudioModel sample = AudioModel(album: "vivek", path: "null" , title: "vivek", id: 2);

  @override
  State<CreatePlaylist> createState() => _CreatePlaylistState();
}

class _CreatePlaylistState extends State<CreatePlaylist> {
  final Box<List<dynamic>>? allSongsBox = Hive.box("allSongsBox");

  // List<AudioModel>? a;

  List<AudioModel> newPlaylist= [];


  // void init(){
  // //  a =newPlaylist;
  // }

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                    color: ColorsForApp.golden.withOpacity(0.5),
                  ))),
                  controller: _controller,
                ),
                ElevatedButton(
                    onPressed: () {
                      putIt(context);
                    },
                    child: Text("Add")),
              ],
            ),
          ),
        );
      },
      child: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Create New Playlist",
              style: StyleForApp.tileDisc,
            ),
            Icon(
              Icons.add,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }

  Future<bool> isUnique(String keyword) async {
    int flag = 0;
    List<String> alreadyPlaylists =
        await allSongsBox!.keys.cast<String>().toList();
    for (String playlist in alreadyPlaylists) {
      if (playlist == keyword) {
        flag = 1;
      }
    }
    if (flag == 1) {
      return false;
    } else
      return true;
  }

  void putIt(context) async {
 
   
    bool isItUnique = await isUnique(_controller.text);
    if (_controller.text.isNotEmpty && isItUnique) {
      final newPlaylistName = _controller.text;
      await allSongsBox!.put(newPlaylistName, newPlaylist);
      widget.setStateOfPlaylistScreen();
      print(await allSongsBox!.values.cast<List<AudioModel>>());
      final snackBar = SnackBar(
          content: Text("New playlist named '${_controller.text}' added."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
    }
    else {
      
      final snackBar = SnackBar(
          content: Text("Playlist named '${_controller.text}' already exists."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}