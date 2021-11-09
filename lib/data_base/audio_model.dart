

import 'package:hive_flutter/hive_flutter.dart';

part 'audio_model.g.dart';

@HiveType(typeId: 0)
class AudioModel extends HiveObject{
  
 AudioModel({this.path,this.title,this.id,this.album,this.duration});
 @HiveField(0)
 String? path ;
 @HiveField(1)
 String? title;

 @HiveField(2)
 int? id;
 @HiveField(3)
 String? album;

 @HiveField(4)
 int? duration;
 

}