import 'package:daily_planner/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late String name;
  late String uid;
  late String cno;
  late String pass;
  late String errorstring;
  final TextEditingController _controller1=TextEditingController();
  final TextEditingController _controller2=TextEditingController();
  final TextEditingController _controller3=TextEditingController();
  final TextEditingController _controller4=TextEditingController();
  bool _obscureText=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        
        children: [
          
          Container
          (
            padding:EdgeInsets.only(left:MediaQuery.of(context).size.width * 0.2,
                top:MediaQuery.of(context).size.height * 0.20),
            child: const Text('Create New Account',style: TextStyle(fontSize: 35,color: Colors.black),),),
            SingleChildScrollView(
              child: Container(
                 padding:EdgeInsets.only(left:MediaQuery.of(context).size.width * 0.2,
                 right:MediaQuery.of(context).size.width * 0.2,
                  top:MediaQuery.of(context).size.height * 0.35),
                child: Column(
                   children: [
                       TextField(decoration: InputDecoration(hintText: 'Enter Name',
                            
                            border: OutlineInputBorder(
                              
                              borderRadius: BorderRadius.circular(10)),
                            ),
                            controller: _controller1,
                            ),
                            const SizedBox(height: 20),
                    TextField(decoration: InputDecoration(hintText: 'Enter Email Id',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              )
                            ),
                             controller: _controller2
                            ),
                            const SizedBox(height: 20),
                    TextField(
                      obscureText: false,
                      controller:_controller3,
                      decoration: InputDecoration(hintText: 'Contact No',
                      
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))
                            ),
                           keyboardType: TextInputType.phone,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            LengthLimitingTextInputFormatter(10) // limit to 10 digits
                          ],
                    ),
                    const SizedBox(height: 20,),
                    TextField(
                      
                      obscureText:_obscureText,
                      controller: _controller4,
                      decoration: InputDecoration(hintText: 'Password',
                      
                            suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))
                            ),
                    ),
                    const SizedBox(height: 20,),
                    
                    ElevatedButton(
                      
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255,58,66,77),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // rounded corner radius
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20), // button padding
                  textStyle: const TextStyle(
                    fontSize: 15, // text size
                    fontWeight: FontWeight.bold, // text weight
                  ),
                ),
                onPressed: () {
                 name=_controller1.text;
                 uid=_controller2.text;
                 cno=_controller3.text;
                 pass=_controller4.text;
                  if(name.isNotEmpty && uid.isNotEmpty &&cno.isNotEmpty && pass.isNotEmpty){
                     String url =
          'https://dailyplanner-f1313-default-rtdb.firebaseio.com/cred.json';
                      http.post(Uri.parse(url),
                body: json.encode({
                  "name": name,
                  "uid": uid,
                  "cno": cno,
                  "pass": pass,
                 
                }));
              
         
                 Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => MainPage(displayName: name, email: uid)),(route) => false,);
                  }
                  else{
                            ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(                 
                      // Undco action
                      content: Text('Enter All the details'),
                      ));
                  }
                   },
                child: const Text('Sign up'), // button label
              ),
              
             ],
                ),
              ),
            )
        ],
      )
      ,
    );
  }
  }
