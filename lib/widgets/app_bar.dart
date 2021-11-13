

import 'package:flutter/material.dart';
import 'package:v_music_player/style/style.dart';

class CustomAppBar {
  static AppBar customAppBar(title,context) {
    double width = MediaQuery.of(context).size.width;
    return AppBar(
      elevation: 2,
      shadowColor: ColorsForApp.golden,
      centerTitle: true,
      backgroundColor: ColorsForApp.light,
      title: Text(
        title,
        style: width<600 ? StyleForApp.heading : StyleForApp.headingLarge,
      ),
      
    );
  }
}
