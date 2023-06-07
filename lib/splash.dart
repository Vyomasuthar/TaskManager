import 'dart:async';
import 'dart:math';

import 'package:daily_planner/login.dart';
import 'package:daily_planner/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
String? finalemail;
String? finalname;
class splash extends StatefulWidget {
  const splash({super.key});

  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {
  @override
  void initState(){
     getValidation().whenComplete(()async {
      Timer(Duration(seconds: 1), (){getValidation();});
    });
    
    super.initState();
  }
  Future<void> getValidation()async {
    final SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    var obtainedmail=sharedPreferences.getString('uid');
    var obtainedname=sharedPreferences.getString('name');
    
      finalemail=obtainedmail;
      finalname=obtainedname;
   
   

    if (finalemail!=null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MainPage(displayName: finalname!,email: finalemail!,)),
      );
    } else {
      await sharedPreferences.setBool('seen', true);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => login()),
      );
    }
    print(finalemail);
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('TaskManager',style: TextStyle(fontSize: 40),)),
    );
  }
}