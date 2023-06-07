import 'dart:math';
import 'package:daily_planner/widgets/Add_event.dart';
import 'package:daily_planner/widgets/Add_event_view.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'model/task.dart';
import 'dart:convert';
class event_calender_view extends StatefulWidget {
 

  
  final String email;
  event_calender_view({required this.email});
  @override
  State<event_calender_view > createState() =>  _event_calender_viewState();
}

class _event_calender_viewState extends State<event_calender_view > {
   late CalendarController _controller;
  final timeFormat = DateFormat('HH:mm');
  late final fsTime;
    late final esTime;


  String _selectedTimeRange = '';
  String _selectedRegion = '';
    final List<DateTime> starttime=[];
     final List<DateTime> endtime=[];
     final List<String> title_desc=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     _controller = CalendarController();
    fetchDataFromFirestore();
      }

       @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

   Future<void> fetchDataFromFirestore() async {
     

     String _taskStart='';
     String _taskEnd='';
     String _title='';
     String _detail='';
     
const String url = 'https://dailyplanner-f1313-default-rtdb.firebaseio.com/task.json';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String,dynamic>;
     
    data.forEach((key, value) {
      if(value['uid']==widget.email){
          String dateStr = value['_date'];
        _taskStart=value['taskStart'];
        _taskEnd =value['taskEnd'];
        _title=value['taskTitle'];
        _detail=value['taskdesc'];
        String combinedDateTimeStr = '$dateStr $_taskStart';
        DateTime combinedDateTime = DateTime.parse(combinedDateTimeStr);
        DateTime combinedDateTime1 = DateTime(combinedDateTime.year,combinedDateTime.month,combinedDateTime.day,combinedDateTime.hour,combinedDateTime.minute,0);
        
        String combinedDateTimeStr2 = '$dateStr $_taskEnd';
        DateTime combinedDateTime2 = DateTime.parse(combinedDateTimeStr2);
        DateTime combinedDateTime3 = DateTime(combinedDateTime2.year,combinedDateTime2.month,combinedDateTime2.day,combinedDateTime2.hour,combinedDateTime2.minute,0);
        String combinedStr4 = '$_title $_detail';
     setState(() {
     
           starttime.add(combinedDateTime1);
        endtime.add(combinedDateTime3);
        title_desc.add(combinedStr4);
       
     });
      }
        
               });
       
        
            
      
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SfCalendar(
          view: CalendarView.week,
          appointmentTextStyle: TextStyle(fontSize: 18,color: Colors.white),
          firstDayOfWeek: 1,
           headerHeight: 0,
              viewHeaderStyle: ViewHeaderStyle(backgroundColor: Colors.transparent),
        controller: _controller,
        
           onSelectionChanged: (calendarSelectionDetails) {
             var a=calendarSelectionDetails.date;
            fsTime=timeFormat.format(a!).toString();
            final esTime1=timeFormat.parse(fsTime!);
            final upesTime=esTime1.add(Duration(hours: 1));
            esTime=timeFormat.format(upesTime).toString();
           },
          showCurrentTimeIndicator: true,
        allowViewNavigation: false,
         onTap: (CalendarTapDetails details)async {
            if (details.targetElement == CalendarElement.calendarCell &&
                details.appointments == null) {
              // Add event when tapping on an empty time region cell
             
                var s=details.date;
                  String dt = DateFormat('yyyy-MM-dd').format(s!);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEventView(selectedDate: dt,fsTimea:fsTime,esTimea:esTime,email:widget.email),
                    ),
                  ).then((value) {
                
             
             
                  },);
             
            }
              
          },
         
        headerStyle: const CalendarHeaderStyle(backgroundColor: Colors.transparent,
        
        ),
        
          dataSource: MeetingDataResource(getAppointments()),
        ),
      ),);
      }
    List<Appointment> getAppointments(){
        List<Appointment> meetings=<Appointment>[];
        
       
        int index=0;
       for(var a in starttime){
            setState(() {
              
               meetings.add(
          Appointment(startTime: a, endTime: endtime[index],color:Colors.primaries[Random().nextInt(Colors.primaries.length)],subject: title_desc[index]),
        );
            });
            
       
         index++;
          
       }
  
    return meetings;
      }
}
  
  class MeetingDataResource extends CalendarDataSource{
    MeetingDataResource(List<Appointment> source){
     appointments=source;
    }
 
  }

  