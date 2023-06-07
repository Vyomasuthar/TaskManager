import 'package:daily_planner/register.dart';
import 'package:daily_planner/widgets/event_calender.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mainPage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
String errorstring='';
final GoogleSignIn googleSignIn = GoogleSignIn(clientId: '1083263612285-la5065hii340uoqblm4quekev1jp6ba3.apps.googleusercontent.com');
 GoogleSignIn? _googleSignIn;
  String _displayName = '';
   bool sign=false;
  String _email = '';
  String _photoUrl = '';
 bool _isSignedIn = false;
 @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn(
    // serverClientId:'1083263612285-la5065hii340uoqblm4quekev1jp6ba3.apps.googleusercontent.com',
     clientId:'1083263612285-la5065hii340uoqblm4quekev1jp6ba3.apps.googleusercontent.com' // Add any additional scopes if needed
    // Add any additional scopes if needed
    );
    _initGoogleSignIn();
  }

  void _initGoogleSignIn() async {
    try {
      await _googleSignIn?.signInSilently();
      setState(() {
        _isSignedIn = _googleSignIn?.currentUser != null;
        if (_isSignedIn) {
          _displayName = _googleSignIn!.currentUser!.displayName!;
          _email = _googleSignIn!.currentUser!.email;
          _photoUrl = _googleSignIn!.currentUser!.photoUrl!;
        }
      });
    } catch (error) {
      print('Error signing in with Google: $error');
    }
  }
  void checkUserdetails()async{

    String a= titleController.text;
    String b=passController.text;
    const String url = 'https://dailyplanner-f1313-default-rtdb.firebaseio.com/cred.json';
     final SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
     final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String,dynamic>;
     data.forEach((key, value) {
       print(value['name']);
    if(value['name']==a && value['pass']==b){
        setState(() {
           sharedPreferences.setString('name',_displayName);
                      sharedPreferences.setString('uid',_email);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context) => MainPage(displayName:value['name'],email:value['uid']),),(route) => false,);
        });
       sign=true;
    }
    
     
    
    });
    if(sign==false){
      setState(() {
         errorstring="Incorrect Credentials";
      });
     }}

  }
   void _handleSignIn() async {
    try {
      await _googleSignIn?.signIn();
       final SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
      setState(() {
        _isSignedIn = true;
         _displayName = _googleSignIn!.currentUser!.displayName!;
        _email = _googleSignIn!.currentUser!.email;
        _photoUrl = _googleSignIn!.currentUser!.photoUrl!;
        
                      sharedPreferences.setString('name',_displayName);
                      sharedPreferences.setString('uid',_email);
        Navigator.push(context, MaterialPageRoute(builder:(context) => MainPage(displayName:_displayName,email:_email),));
      });
    } catch (error) {
      print('Error signing in with Google: $error');
    }
  }
   void _handleSignOut() async {
    try {
      await _googleSignIn?.signOut();
      setState(() {
        _isSignedIn = false;
      });
    } catch (error) {
      print('Error signing out: $error');
    }
  }

 final titleController=TextEditingController();
  final passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false,
      theme: ThemeData(
      
      ),
      home: Scaffold(
        
        body: Stack(
          children:[ SingleChildScrollView(
            child: Column(
              
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isSignedIn)
                  Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          _googleSignIn!.currentUser!.photoUrl!,
                        ),
                        radius: 40,
                      ),
                      const SizedBox(height: 16),
                      Text(_googleSignIn!.currentUser!.displayName!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _handleSignOut,
                        child: const Text('Sign Out'),
                      ),
                    ],
                  )
                else
                  SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(top:MediaQuery.of(context).size.height * 0.20,
                      left:MediaQuery.of(context).size.width * 0.1,
                     right:MediaQuery.of(context).size.width * 0.10,),
                      
                      child: Text('Sign In to Task Manager',
                      
                                    style: TextStyle(color: Colors.black,fontSize: 30),),
                    ),
                  ),
                SizedBox(height: 30,),
                Container(
                   padding:EdgeInsets.only(left:MediaQuery.of(context).size.width * 0.20,
                   right:MediaQuery.of(context).size.width * 0.20,
                   ),
                  child: Column(children: [
                    
              
                 TextField(
                  controller: titleController,
                  cursorColor: Colors.black,
                  textCapitalization: TextCapitalization.words,
                 
                  decoration: const InputDecoration(
                   border: OutlineInputBorder(
                                borderSide: BorderSide(
                              style: BorderStyle.solid,
                              color: Colors.black,
                              
                            )),
                    floatingLabelStyle: TextStyle(color: Colors.black),
                            focusColor: Colors.black,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  style: BorderStyle.solid, color: Colors.black),
                            ),
                    labelText: 'Username',
                  ),
                ),
                SizedBox(height: 30,),
                 TextField(
                   obscureText: true,
                  controller: passController,
                   cursorColor: Colors.black,
                   
                  textCapitalization: TextCapitalization.words,
                  
                  decoration: const InputDecoration(
                   border: OutlineInputBorder(
                                borderSide: BorderSide(
                              style: BorderStyle.solid,
                              color: Colors.black,
                              
                            )),
                    floatingLabelStyle: TextStyle(color: Colors.black),
                            focusColor: Colors.black,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  style: BorderStyle.solid, color: Colors.black),
                            ),
                    labelText: 'Password',
                  ),
                ),SizedBox(height: 20,),
                 Container(child: Text(errorstring)),
                SizedBox(height: 40,),
                 
                  ElevatedButton(
                    
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
              
                      backgroundColor: Colors.black,
                      textStyle: TextStyle(fontSize: 20),
                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: EdgeInsets.only(left: 80,right:80,bottom:12 ,top:12)
                    ),
                    onPressed:checkUserdetails,                    
                    
                    child: const Text('Sign In'),
                  ),
                   SizedBox(height: 10,),
                 
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                      textStyle: TextStyle(fontSize: 20),
                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: EdgeInsets.only(left: 25,right: 25,bottom:12 ,top:12)
                    ),
                    onPressed: 
                    _handleSignIn
                    
                    ,
                    child: const Text('Sign in with Google'),
                  ),
                   SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.only(left:MediaQuery.of(context).size.width * 0.01),
                  child: Row(
                    children: [Text('Dont Have an Account?',style: TextStyle(fontSize: 15),),SizedBox(width:5),
                  TextButton(
                  onPressed:(){
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>Register()));
                  },
                  child: Text('Sign Up',style: TextStyle(decoration: TextDecoration.underline,fontSize: 15,color: Color.fromARGB(255,58,66,77)),))],),
                )

                ]),)
              ],
            ),
          ),
          ]),
      ),
    );
  }
}

