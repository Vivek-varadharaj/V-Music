import 'package:flutter/material.dart';
import 'package:v_music_player/style/style.dart';

class CustomAppBar {
  static AppBar customAppBar(title) {
    return AppBar(
      elevation: 2,
      shadowColor: ColorsForApp.golden,
      centerTitle: true,
      backgroundColor: ColorsForApp.light,
      title: Text(
        title,
        style: StyleForApp.heading,
      ),
      
    );
  }
}
