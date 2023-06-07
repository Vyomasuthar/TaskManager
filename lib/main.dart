
import 'package:daily_planner/event_calender_view.dart';
import 'package:daily_planner/register.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:daily_planner/splash.dart';
import 'package:daily_planner/widgets/event_calender.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'package:flutter/material.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options:FirebaseOptions(apiKey: "AIzaSyAGK60MOrnN2OtISj3NqWhKp--E-b4LpRI", appId:"1:1083263612285:web:f663301163760fdfdbc814", messagingSenderId:"1083263612285", projectId: 'dailyplanner-f1313'));
   
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner:false,
      home:splash(),
      
      
    );
  }
}


