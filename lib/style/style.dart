import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ColorsForApp {
  static Color light = Color(0xff010101);
  static Color dark = Color(0xff010101);
  static Color golden = Color(0xffD4AF37);
  static Color goldenLow = Color(0xff8B6039);
}

class StyleForApp {
  static TextStyle heading =
      GoogleFonts.yanoneKaffeesatz(color: Colors.white, fontSize: 18);
  static TextStyle tileDisc = GoogleFonts.yanoneKaffeesatz(
    color: Colors.white,
    fontSize: 16,
  );

  static TextStyle headingLarge =
      GoogleFonts.yanoneKaffeesatz(color: Colors.white, fontSize: 28);
  static TextStyle tileDiscLarge = GoogleFonts.lora(
    color: Colors.white,
    fontSize: 24,
  );

  static Gradient bodyGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.black, Colors.black87, Colors.black54, Colors.black]);

 

  static Gradient bodyGradient2 = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xff195D75),
        Color(0xff1B6E76),
        Colors.black87,
        Colors.black
      ]);

  static Gradient bodyGradient3 = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xff492900),
        Color(0xff492900),
       
        Colors.black87,
        Colors.black
      ]);

  static Gradient? bodyTheme;
  static int? themeNumber1;
  static void setTheme(themeNumber) {
    themeNumber1 = themeNumber;
    if (themeNumber == 1) {
      bodyTheme = bodyGradient;
    } else if (themeNumber == 2) {
     
   
      bodyTheme = bodyGradient2;
    }else if(themeNumber==3){
      bodyTheme = bodyGradient3;
    }
  }

  static int getThemeNumber() {
    return themeNumber1!;
  }

  static List<Color> darkColors = [
    Color(0xff400000),
    Color(0xff010029),
    Color(0xff1D0024),
    Color(0xff152D32),
    Color(0xff001F24),
    Color(0xff2F3B22),
    Color(0xff442106),
    Color(0xff761512),
    Color(0xff400000),
    Color(0xff010029),
    Color(0xff1D0024),
    Color(0xff152D32),
    Color(0xff001F24),
    Color(0xff2F3B22),
    Color(0xff442106),
    Color(0xff761512),
  ];
}
