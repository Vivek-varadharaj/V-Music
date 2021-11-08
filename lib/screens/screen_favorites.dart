import 'package:flutter/material.dart';
import 'package:v_music_player/widgets/app_bar.dart';

class Favorites extends StatelessWidget {
  const Favorites({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomAppBar.customAppBar("Favorites"),
      
    );
  }
}