import 'dart:convert';
import 'package:daily_planner/widgets/RadioOptionsDialog.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'model/task.dart';
import 'notification.dart';
class editEvent extends StatefulWidget {
 final String email;
 
 final String selectedDate;

  const editEvent({super.key, required this.selectedDate,required this.email});

  @override
  State<editEvent> createState() => _editEventState();
}

class _editEventState extends State<editEvent> {
notificationServicrd  _notificationServices=notificationServicrd();

  TimeOfDay _selectedTime=TimeOfDay.now();
  TimeOfDay _selectedTime2=TimeOfDay.now();
   @override
   
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDataFromFirestore().then((value) {
      setState(() {
        titleController.text=tasks.taskTitle;
        descController.text=tasks.taskdesc;
       
        locController.text=tasks.taskloc;
        repeatController.text=tasks.repeat;
         DateFormat dateFormat = DateFormat.Hm();
DateTime parsedTime = dateFormat.parse(tasks.taskStart);
_selectedTime = TimeOfDay.fromDateTime(parsedTime);
_selectedTime2 = TimeOfDay.fromDateTime(dateFormat.parse(tasks.taskEnd));
      });
    });
  _notificationServices.initializeNotification();
    
   
  }
  late task tasks;
int count=0;
List<String> texts=[];
List<String> rems=['Before 10 Minutes','Before 20 Minutes','Before 30 Minutes'];


   String _formattedTime = '';
   
   String _formattedTime2 = '';
    Map<String,dynamic> data={};
      List<Widget> _buttons = [];
  final titleController=TextEditingController();
  final descController = TextEditingController();
  final timeController = TextEditingController();
  final endController = TextEditingController();
  final locController = TextEditingController();
  final repeatController = TextEditingController();
   static const databaseUrl = 'https://dailyplanner-f1313-default-rtdb.firebaseio.com/task.json';

  


  final url = databaseUrl;
 

 Future<void> _selectTime(BuildContext context) async {
 
print(_selectedTime);
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
        _formattedTime = '${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}';
      });
    }
  }
  Future<void> _selectTime2(BuildContext context) async {

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime:_selectedTime2,
    );
    if (pickedTime != null && pickedTime != _selectedTime2) {
      setState(() {
        _selectedTime2 = pickedTime;
        _formattedTime2 = '${_selectedTime2.hour}:${_selectedTime2.minute.toString().padLeft(2, '0')}';
      });
    }
  }
  void _addButton() {

    print(rems);
    setState(() {
        texts.add(rems[count]);
      _buttons.add(
        
        ElevatedButton(
          child: Text(rems[count]),

          onPressed: () {
            // Handle dynamic button click
          },
        ),
      );
      
        count++;
    });
  }

  Future<void> updateDataByDate() async {
  const String url = 'https://dailyplanner-f1313-default-rtdb.firebaseio.com/task.json';

  final response = await http.get(Uri.parse(url));
  var matchingDocument ='';
  if (response.statusCode == 200) {
    final data = json.decode(response.body) as Map<String,dynamic>;
   for(final entry in data.entries){
     final docdata=entry.value as  Map<String,dynamic>;
     if(docdata['_date']==widget.selectedDate){
       matchingDocument=entry.key;
     }
   }
     

    if (matchingDocument != null) {
      final documentId = matchingDocument;
      print(documentId);
      final updateUrl = 'https://dailyplanner-f1313-default-rtdb.firebaseio.com/task/$documentId.json';
       if (repeatController.text.isEmpty) {
                  repeatController.text = '';}
                  else{
                     if(repeatController.text=='Every Day'){
                       _notificationServices.cancelnoti();
                    _notificationServices.scheduleNoti(titleController.text,descController.text);
                }
                 if(repeatController.text=='Every Week'){
                     _notificationServices.cancelnoti();
                    _notificationServices.scheduleNotiweek(titleController.text,descController.text);
                }
                  }
      final updateResponse = await http.patch(
        Uri.parse(updateUrl),
        body: json.encode({  "taskTitle" : titleController.text,
                        "taskdesc" : descController.text,
                        "taskStart":_formattedTime,
                        "taskEnd":_formattedTime2,
                        "taskloc":locController.text,
                        "repeat":repeatController.text,
                        "remainder":texts.toString(),
                        "_date":widget.selectedDate,
                          "uid":widget.email}),
                        
      );

      if (updateResponse.statusCode == 200) {
        print('Data updated successfully');
        setState(() {
          Navigator.pop(context);
        });
      } else {
        print('Failed to update data. Error: ${updateResponse.reasonPhrase}');
      }
    } else {
      print('Document not found for the selected date.');

    }
  } else {
    print('Failed to fetch data. Error: ${response.reasonPhrase}');
  }
  
}

  @override
  Widget build(BuildContext context) {
    
    return 
    Scaffold(
       appBar: AppBar(title: Text('Edit Event'),foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                shadowColor: Colors.transparent,),
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
                    
                  ), SizedBox(height: 10),
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
                   TextField(
                      style: TextStyle(fontSize: 18, color: Colors.black),
                     decoration: const InputDecoration(
                            labelText: 'Start Time',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                              style: BorderStyle.solid,
                              color: Colors.black,
                            )),
                            prefixIcon: Icon(Icons.access_time),
                            prefixIconColor: Colors.grey,
                            floatingLabelStyle: TextStyle(color: Colors.black),
                            focusColor: Colors.black,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  style: BorderStyle.solid, color: Colors.black),
                            )),
                                      controller: TextEditingController(text: _formattedTime),
                                      onTap:() {_selectTime(context);},
                                      ),
                                      SizedBox(height: 10),
                   TextField(
                      style: TextStyle(fontSize: 18, color: Colors.black),
                        decoration: const InputDecoration(
                            labelText: 'End Time',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                              style: BorderStyle.solid,
                              color: Colors.black,
                            )),
                            prefixIcon: Icon(Icons.access_time  ),
                            prefixIconColor: Colors.grey,
                            floatingLabelStyle: TextStyle(color: Colors.black),
                            focusColor: Colors.black,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  style: BorderStyle.solid, color: Colors.black),
                            )),
                                      controller: TextEditingController(text: _formattedTime2),
                                      onTap:() {_selectTime2(context);},
                                      ),
                                      SizedBox(height: 10),
                  TextField(
                    controller: locController,
                      style: TextStyle(fontSize: 18, color: Colors.black),           
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
                  ),SizedBox(height: 10),
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
                    );}
                  
                
                  );}), SizedBox(height: 10,),
                  Column(
                         children: [
                         ButtonBar(alignment: MainAxisAlignment.start,
                            buttonPadding: EdgeInsets.all(10),
                           children:[ ElevatedButton(
                              style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.grey),
                              foregroundColor: MaterialStatePropertyAll(Colors.black)),
                             onPressed:_addButton,
                             child: Text('Add Remainder')),
                         
                             SizedBox(height: 16),
                             ..._buttons],),
                        ],
                          
                       ),SizedBox(height: 20,),    
                       FloatingActionButton.extended(onPressed:updateDataByDate, label:const Text('Add',style: TextStyle(fontSize: 15),),
                     foregroundColor: Colors.white,
                      backgroundColor: Colors.black, 

                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(90)),)
                ],
            ),
        ),
      )
    );
  }
  
   Future<void> fetchDataFromFirestore() async {
     

     String _taskStart='';
     String _taskEnd='';
     String _taskTitle='';
     String _taskdesc='';
     String _taskloc='';
     String _remainder='';
     String _repeat='';
     

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String,dynamic>;
     data.forEach((key, value) {
    if(value['_date']==widget.selectedDate){
     setState(() {
        _taskStart= value['taskStart'];
      _taskEnd = value['taskEnd'];
       _taskTitle = value['taskTitle'];
       _taskdesc = value['taskdesc'];
       _taskloc = value['taskloc'];
       _remainder = value['remainder'];
       _repeat = value['repeat'];
     });
    
      tasks= task(taskStart:_taskStart ,taskEnd:_taskEnd ,taskTitle: _taskTitle,taskdesc:_taskdesc ,taskloc:_taskloc ,remainder: _remainder,repeat:_repeat );
   
      }});
    
      
    }
  }
}