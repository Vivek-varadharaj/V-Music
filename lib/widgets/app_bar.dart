

import 'package:flutter/material.dart';
import 'package:v_music_player/style/style.dart';

class CustomAppBar {
  static AppBar customAppBar(title,context) {
    int theme = StyleForApp.getThemeNumber();
    double width = MediaQuery.of(context).size.width;
    return AppBar(
      elevation:0,
      
      centerTitle: true,
      backgroundColor:theme ==1 ? Colors.black :theme==3? Color(0xff492900) : Color(0xff195D75),
      title: Text(
        title,
        style: width<600 ? StyleForApp.heading : StyleForApp.headingLarge,
      ),
      
    );
  }
}
