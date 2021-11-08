import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:v_music_player/style/style.dart';
import 'package:v_music_player/widgets/app_bar.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({ Key? key }) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsForApp.dark,
      appBar: CustomAppBar.customAppBar("Search"),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 8),
            child: TextField(
              controller: _controller,
              style: StyleForApp.tileDisc,
              decoration: InputDecoration(
                labelText: "Search",
                labelStyle: StyleForApp.tileDisc,
               suffixIcon: Icon(FontAwesomeIcons.search,color: ColorsForApp.golden.withOpacity(0.5),),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorsForApp.golden.withOpacity(0.5),
                  width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorsForApp.golden.withOpacity(0.5),
                  width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorsForApp.golden.withOpacity(0.5),
                  width: 1),
              ),
            ),
            onChanged: (keyword){
              //TODO implement search logic here. Will need an array 
            },
            ),
          ),


        ],
      ),
    );
  }
}