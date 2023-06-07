      import 'dart:convert';
import 'dart:math';
      import 'package:daily_planner/event_calender_view.dart';
import 'package:http/http.dart' as http;
      import 'package:flutter/material.dart';
      import 'package:url_launcher/url_launcher.dart';
      import '../notification.dart';
import 'RadioOptionsDialog.dart';

      class AddEventView extends StatefulWidget {
        final String selectedDate;
        final String fsTimea;
        final String esTimea;
        final String email;
        const AddEventView({super.key, required this.selectedDate,required this.fsTimea,required this.esTimea,required this.email});

        @override
        State<AddEventView> createState() => AddEventViewState();
      }

      class AddEventViewState extends State<AddEventView> {
        AddEventViewState();
notificationServicrd  _notificationServices=notificationServicrd();
@override
  void initState(){
    super.initState();
  _notificationServices.initializeNotification();


}
        List<Widget> _buttons = [];
        final titleController = TextEditingController();
        final descController = TextEditingController();
        final timeController = TextEditingController();
        final endController = TextEditingController();
        final locController = TextEditingController();
        final repeatController = TextEditingController();

        String url =
            'https://dailyplanner-f1313-default-rtdb.firebaseio.com/task.json';
        int count = 0;
        List<String> texts = [];
        List<String> rems = [
          'Before 10 Minutes',
          'Before 20 Minutes',
          'Before 30 Minutes'
        ];

        TimeOfDay _selectedTime = TimeOfDay.now();
        String _formattedTime = '';
        String _formattedTime2 = '';
        DateTime? _selectedDate;
        Future<void> _selectTime(BuildContext context) async {
          final TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: _selectedTime,
          );
          if (pickedTime != null && pickedTime != _selectedTime) {
            setState(() {
              _selectedTime = pickedTime;
              _formattedTime =
                  '${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}';
            });
          }
        }

        Future<void> _selectTime2(BuildContext context) async {
          final TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: _selectedTime,
          );
          if (pickedTime != null && pickedTime != _selectedTime) {
            setState(() {
              _selectedTime = pickedTime;
              _formattedTime2 =
                  '${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}';
            });
          }
        }

        void _addButton() {
          print(count);
          setState(() {
            texts.add(rems[count]);
            _buttons.add(
              ElevatedButton(
                 style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.grey),
                              foregroundColor: MaterialStatePropertyAll(Colors.black),
                     ),
                              
                child: Text(rems[count]),
                onPressed: () {
                  // Handle dynamic button click
                },
              ),
            );

            count++;
          });
        }

        _addTask() {
          if (titleController.text.isEmpty &&
              descController.text.isEmpty 
          ) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Enter all details"),
              duration: Duration(seconds: 2),
            ));

            return;
          } else {
            if (locController.text.isEmpty ||
                repeatController.text.isEmpty ||
                repeatController.text.isEmpty) {
              if (locController.text.isEmpty) {
                locController.text = '';}
                if (repeatController.text.isEmpty) {
                  repeatController.text = '';}
                  else{
                     if(repeatController.text=='Every Day'){
                    _notificationServices.scheduleNoti(titleController.text,descController.text);
                }
                 if(repeatController.text=='Every Week'){
                    _notificationServices.scheduleNotiweek(titleController.text,descController.text);
                }
                  }
                  if (texts.isEmpty) {
                    texts = [];
                  }
                
              
            }
            setState(() {
              http.post(Uri.parse(url),
                  body: json.encode({
                    "taskTitle": titleController.text,
                    "taskdesc": descController.text,
                    "taskStart": widget.fsTimea,
                    "taskEnd": widget.esTimea,
                    "taskloc": locController.text,
                    "repeat": repeatController.text,
                    "remainder": texts.toString(),
                    "_date": widget.selectedDate,
                      "uid":widget.email
                  }));
                
             Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => event_calender_view(email: widget.email,),
                    ),
                  );
            });
          }
        }

        @override
        Widget build(BuildContext context) {
          return Scaffold(
              appBar: AppBar(
                title: Text('Add new Event'),
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                shadowColor: Colors.transparent,
              ),
              body: SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.20,
                    right: MediaQuery.of(context).size.width * 0.20,
                    top: MediaQuery.of(context).size.height * 0.05,
                  ),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        controller: titleController,
                        cursorColor: Colors.black,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                              style: BorderStyle.solid,
                              color: Colors.black,
                            )),
                            labelText: 'Title',
                            prefixIcon: Icon(Icons.edit),
                            prefixIconColor: Colors.grey,
                            floatingLabelStyle: TextStyle(color: Colors.black),
                            focusColor: Colors.black,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  style: BorderStyle.solid, color: Colors.black),
                            )),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        maxLines: 2,
                        maxLength: 100,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        controller: descController,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                              style: BorderStyle.solid,
                              color: Colors.black,
                            )),
                            prefixIcon: Icon(Icons.description),
                            prefixIconColor: Colors.grey,
                            floatingLabelStyle: TextStyle(color: Colors.black),
                            focusColor: Colors.black,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  style: BorderStyle.solid, color: Colors.black),
                            )),
                      ),
                     
                      SizedBox(height: 10),
                      TextField(
                         style: TextStyle(fontSize: 18, color: Colors.black),
                        controller: locController,
                        textCapitalization: TextCapitalization.words,
                         decoration: const InputDecoration(
                            labelText: 'Location',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                              style: BorderStyle.solid,
                              color: Colors.black,
                            )),
                            prefixIcon: Icon(Icons.location_on),
                            prefixIconColor: Colors.grey,
                            floatingLabelStyle: TextStyle(color: Colors.black),
                            focusColor: Colors.black,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  style: BorderStyle.solid, color: Colors.black),
                            )),
                      ), SizedBox(height: 10),
                      TextField(
                         style: TextStyle(fontSize: 18, color: Colors.black),
                           decoration: const InputDecoration(
                            labelText: 'Repeat',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                              style: BorderStyle.solid,
                              color: Colors.black,
                            )),
                            prefixIcon: Icon(Icons.repeat_on),
                            prefixIconColor: Colors.grey,
                            floatingLabelStyle: TextStyle(color: Colors.black),
                            focusColor: Colors.black,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  style: BorderStyle.solid, color: Colors.black),
                            )),
                          controller: repeatController,
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return RadioOptionsDialog(
                                    textEditingController: repeatController,
                                  );
                                });
                          }),
                          SizedBox(height: 10,),
                      Column(
                        
                        children: [
                          ButtonBar(alignment: MainAxisAlignment.start,
                            buttonPadding: EdgeInsets.all(10),
                            children: [ ElevatedButton( 
                            style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.grey),
                              foregroundColor: MaterialStatePropertyAll(Colors.black)),
                              onPressed: _addButton, child: const Text('Add Remainder')),
                         
                          ..._buttons],),
                         
                        ],
                      ),
                      SizedBox(height: 20,),
                      FloatingActionButton.extended(onPressed: _addTask, label: const Text('Save Task',style: TextStyle(fontSize: 15),),
                     foregroundColor: Colors.white,
                      backgroundColor: Colors.black, 

                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(90)),   ),                  
         
                    ],
                  ),
                ),
              ));
        }
      }
