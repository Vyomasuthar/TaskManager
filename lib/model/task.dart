import 'package:flutter/foundation.dart';
class task {
  final String taskTitle;
  final String taskdesc;
  final String taskStart;
  final String taskEnd;
  final String taskloc;
  
  final String repeat;
  final String remainder;
 task({required this.repeat,required this.remainder,required this.taskTitle,required this.taskdesc,required this.taskStart,required this.taskEnd,required this.taskloc});
}
class idData{
  final String displayName;
  final String email;
  final String photoUrl;
  idData({required this.displayName,required this.email,required this.photoUrl});
}