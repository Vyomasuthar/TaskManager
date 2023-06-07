  // https://youtu.be/tiLu2PDmwC0
  //https://youtu.be/_LhFPqIjKxEx

  import 'dart:math';

  import 'package:daily_planner/editEvent.dart';
import 'package:daily_planner/model/task.dart';
  import 'package:flutter/material.dart';
  import 'package:intl/intl.dart';
  import 'Add_event.dart';
  import 'package:table_calendar/table_calendar.dart';
  import 'dart:convert';
  import '../editEvent.dart';
  import 'package:http/http.dart' as http;

  class event_calender extends StatefulWidget {
    String email;
    event_calender({required this.email});
    @override
    State<event_calender> createState() => _event_calenderState();
  }

  class _event_calenderState extends State<event_calender> {
    String url =
        'https://dailyplanner-f1313-default-rtdb.firebaseio.com/task.json';
    Map<String, dynamic> myTasks = {};
    CalendarFormat _calenderFormat = CalendarFormat.month;
    Map<String, dynamic> data = {};
    DateTime _focusedDay = DateTime.now();
    DateTime _selectedDate = DateTime.now();
    List<bool> _isCheckedList=[];
     late Map<String, int> dateOccurrences = <String, int>{};
    List<String> _eventList = [];
List<String> dates=[];
    @override
    void initState() {
      super.initState();
      setState(() {
        getData(_selectedDate);
      
      });
      // TODO: implement initState
      _selectedDate = _focusedDay;

      // getData();
      //_loadPreviousEvent();
    }

    getData(DateTime selectedDay) async {
      const databaseUrl =
          'https://dailyplanner-f1313-default-rtdb.firebaseio.com/';

      final dataPath = 'task';

      final url = '$databaseUrl$dataPath.json';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        String dt1 = DateFormat('yyyy-MM-dd').format(selectedDay);
        print('in getdata selected method $dt1'); 
        data = jsonDecode(response.body) as Map<String, dynamic>;
        print(data['_date']);
        _isCheckedList=[];
        setState(() {
          _eventList = [];
          data.forEach(
            (key, value) {
              if (value['_date'] == dt1 && value['uid']==widget.email) {
                String a = value['taskTitle'];
                _eventList.add(a);  
                print(value['checked']);
               

               _isCheckedList.add(value['checked']);
              }
            },
          );
          print(_isCheckedList);
        });
 print(_eventList);
        return _eventList;
      } else {
        // Handle the error
        print('Failed to get data from Firebase Realtime Database. '
            'Status code: ${response.statusCode}, '
            'Error message: ${response.reasonPhrase}');

        return _eventList;
      }
    }

    Future<void> CompletedTaskDate(String a) async {
      const String url =
          'https://dailyplanner-f1313-default-rtdb.firebaseio.com/task.json';

      final response = await http.get(Uri.parse(url));
      var matchingDocument = '';
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        for (final entry in data.entries) {
          final docdata = entry.value as Map<String, dynamic>;
          if (docdata['taskTitle'] == a) {
            matchingDocument = entry.key;
          }
        }

        if (matchingDocument != null) {
          final documentId = matchingDocument;
          print(documentId);
          final updateUrl =
              'https://dailyplanner-f1313-default-rtdb.firebaseio.com/task/$documentId.json';
          const String url =
              'https://dailyplanner-f1313-default-rtdb.firebaseio.com/Completedtask.json';

          final response = await http.get(Uri.parse(updateUrl));

          if (response.statusCode == 200) {
            final data = json.decode(response.body) as Map<String, dynamic>;
            data['checked']=true;
            setState(() {
               http.patch(Uri.parse(updateUrl), body: json.encode(data));
            http.post(Uri.parse(url), body: json.encode(data));
            });
            
          }
        }
      }
    }

    Future<void> notCompleted(String a) async {
      const String url =
          'https://dailyplanner-f1313-default-rtdb.firebaseio.com/Completedtask.json';

      final response = await http.get(Uri.parse(url));
      var matchingDocument = '';
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        for (final entry in data.entries) {
          final docdata = entry.value as Map<String, dynamic>;
          if (docdata['taskTitle'] == a) {
            matchingDocument = entry.key;
          } else {
            print('No data found');
          }
        }

        if (matchingDocument != null) {
          final documentId = matchingDocument;
          print(documentId);
          final updateUrl =
              'https://dailyplanner-f1313-default-rtdb.firebaseio.com/Completedtask/$documentId.json';

          final response = await http.delete(Uri.parse(updateUrl));

          if (response.statusCode == 200) {
            print("data deleted");
          }
        }
      }
    }

    Future<void> deleteTask(String a) async {
      const String url =
          'https://dailyplanner-f1313-default-rtdb.firebaseio.com/task.json';

      final response = await http.get(Uri.parse(url));
      var matchingDocument = '';
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        for (final entry in data.entries) {
          final docdata = entry.value as Map<String, dynamic>;
          if (docdata['taskTitle'] == a) {
            matchingDocument = entry.key;
          }
        }

        if (matchingDocument != null) {
          final documentId = matchingDocument;
          print(documentId);
          final updateUrl =
              'https://dailyplanner-f1313-default-rtdb.firebaseio.com/task/$documentId.json';

          final response = await http.delete(Uri.parse(updateUrl));

          if (response.statusCode == 200) {
            print("data deleted");
          }
        }
      }
    }

    
    @override
    Widget build(BuildContext context) {
     
      return Scaffold(
        body: Center(
          child: Container(
            color: Colors.white,
            child: Column(children: <Widget>[
              TableCalendar(
             
                focusedDay: _focusedDay,
                firstDay: DateTime(2023, 1, 1),
                lastDay: DateTime(2024, 1, 1),
                rowHeight: 60,
        
                daysOfWeekHeight: 30,
                calendarFormat: _calenderFormat,
                daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(fontSize: 20),
                    weekendStyle: TextStyle(fontSize: 20)),
                calendarStyle: CalendarStyle(
                    cellPadding: EdgeInsets.all(10),
                    outsideTextStyle: TextStyle(fontSize: 20),
                    defaultTextStyle: TextStyle(fontSize: 20),
                    weekNumberTextStyle: TextStyle(fontSize: 20),
                    weekendTextStyle: TextStyle(fontSize: 20),
                    withinRangeTextStyle: TextStyle(fontSize: 20),
                   
                    selectedTextStyle: TextStyle(fontSize: 20)),
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDate, selectedDay)) {
                    setState(() {
                      getData(selectedDay);
                      _selectedDate = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }
                },
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDate, day);
                },
                onFormatChanged: (format) {
                  if (_calenderFormat != format) {
                    setState(() {
                      _calenderFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                headerStyle: HeaderStyle(
                  formatButtonVisible: true,
                  titleCentered: true,
                  titleTextStyle: TextStyle(fontSize: 28),
                ),
                availableGestures: AvailableGestures.all,
              ),
              FloatingActionButton.extended(
                onPressed: () {
                  String dt = DateFormat('yyyy-MM-dd').format(_selectedDate);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEvent(selectedDate: dt,email: widget.email),
                    ),
                  );
                },
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                label: const Text(
                  "Create Task",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 13.0),
                          leading: Container(
                            width: MediaQuery.of(context).size.width * 0.14,
                            child: Row(
                              children: [
                                Container(
                                  height: 27.0,
                                  width: 4.0,
                                  color: Colors.primaries[
                                      Random().nextInt(Colors.primaries.length)],
                                ),
                                Checkbox(
                                  value: _isCheckedList[index],
                                  onChanged: (value) {
                                    setState(() {
                                      _isCheckedList[index] = value!;
                                      if (_isCheckedList[index] == true) {
                                        CompletedTaskDate(
                                            _eventList[index].toString());
                                      }
                                      if (_isCheckedList[index] == false) {
                                        notCompleted(
                                            _eventList[index].toString());
                                      }
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                          title: Text(_eventList[index]),
                          trailing: Container(
                            width:MediaQuery.of(context).size.width * 0.25,
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      String dt = DateFormat('yyyy-MM-dd')
                                          .format(_selectedDate);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              editEvent(selectedDate: dt,email:widget.email),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        deleteTask(_eventList[index].toString());
                                        _eventList.removeAt(index);
                                      });
                                    },
                                    icon: const Icon(Icons.delete)),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: _eventList.length),
              )
            ]),
          ),
        ),
      );
    }
  }
