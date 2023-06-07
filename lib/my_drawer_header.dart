import 'package:flutter/material.dart';

class MyHeaderDrawer extends StatefulWidget {
  final String displayName;
  final String email;
  const MyHeaderDrawer({super.key, required this.displayName,required this.email});
  @override
  _MyHeaderDrawerState createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         
          Text(
            widget.displayName,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          Text(
            widget.email,
            style: TextStyle(
              color: Colors.grey[200],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}