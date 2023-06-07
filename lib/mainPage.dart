import 'dart:math';

import 'package:daily_planner/event_calender_view.dart';
import 'package:daily_planner/login.dart';
import 'package:daily_planner/main.dart';
import 'package:flutter/material.dart';
import 'package:daily_planner/widgets/event_calender.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chart.dart';
import 'my_drawer_header.dart';

class MainPage extends StatefulWidget {
  final String displayName;
  final String email;

  const MainPage({required this.displayName, required this.email});

  @override
  State<MainPage> createState() => _MainPageState();
}

   

class _MainPageState extends State<MainPage> {
  var currentPage = DrawerSections.event_calender;
 Future<void> _logout(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
   await sharedPreferences.clear();
    Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (BuildContext context) => login()),
    (Route<dynamic> route) => false,
  );
    // Other logout operations, such as navigating to the login screen
   
  }
  @override
  Widget build(BuildContext context) {
    var container;
    if (currentPage == DrawerSections.event_calender) {
      container = event_calender(email: widget.email);
    } else if (currentPage == DrawerSections.chart) {
      container = chart();
    } else if (currentPage == DrawerSections.logout) {
      // Handle logout actions
    
        _logout(context);
    
      
    }

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => event_calender_view(email: widget.email),
                ),
              );
            },
            icon: Icon(Icons.event),
          )
        ],
        title: Text('Events'),
      ),
      body: 
    
      container,
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                MyHeaderDrawer(displayName: widget.displayName, email: widget.email),
                MyDrawerList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget MyDrawerList() {
    return Container(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        children: [
          menuItem(
            DrawerSections.event_calender,
            "Create Events",
            Icons.create,
            currentPage == DrawerSections.event_calender,
          ),
          Divider(),
          menuItem(
            DrawerSections.chart,
            "Completed Task",
            Icons.task,
            currentPage == DrawerSections.chart,
          ),
          Divider(),
          menuItem(
            DrawerSections.logout,
            "Log Out",
            Icons.logout,
            currentPage == DrawerSections.logout,
          ),
        ],
      ),
    );
  }

  Widget menuItem(DrawerSections section, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            currentPage = section;
          });
        },
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.black,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum DrawerSections {
  event_calender,
  editEvent,
  chart,
  logout
  
}