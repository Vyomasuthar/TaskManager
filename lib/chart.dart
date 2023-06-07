import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'dart:core';
  import 'package:http/http.dart' as http;
  
class chart extends StatefulWidget {
  
@override
State<chart> createState() => _chartAppState();
}
 List<bool> _isCheckedList=[];
    List<String> _eventList = [];
class _chartAppState extends State<chart>{
 List<ChartData> chartDataList = [];
  late TooltipBehavior _tooltip;
      Map<String, dynamic> data = {};
 late Map<String, int> dateOccurrences1 = <String, int>{};

Future<Map<String, dynamic>> fetchFirebaseData() async {

  final response = await http.get(Uri.parse('https://dailyplanner-f1313-default-rtdb.firebaseio.com/Completedtask.json'));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to fetch data from Firebase');
  }
}
Future<void> countDateOccurrences() async {
  final data = await fetchFirebaseData();
  final dateOccurrences = <String, int>{};
  

  // Process the data and count date occurrences
  data.forEach((key, value) {
    final date = value['_date']; 
   
    // Extract the date part from the key
    if (dateOccurrences.containsKey(date)) {
       dateOccurrences[date] =dateOccurrences[date]!+1;
     } else {
       dateOccurrences[date] = 1;
     }
   });
   setState(() {
     
  chartDataList = dateOccurrences.entries.map((entry) {
  final category = entry.key;
  final value1 = entry.value;
  return ChartData(category, value1 as int);
}).toList();
  
   });
 
}

@override
  void initState() {
    // TODO: implement initState
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
    countDateOccurrences();
    setState(() {
        getData();
      
      });
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

  
    getData() async {
      const databaseUrl =
          'https://dailyplanner-f1313-default-rtdb.firebaseio.com/';

      final dataPath = 'task';

      final url = '$databaseUrl$dataPath.json';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
       
        data = jsonDecode(response.body) as Map<String, dynamic>;
        print(data['_date']);
        _isCheckedList=[];
        setState(() {
          _eventList = [];
          data.forEach(
            (key, value) {
              if (value['checked'] == false) {
                String a = value['taskTitle'];
                _eventList.add(a);  
                print(value['checked']);
               

               _isCheckedList.add(value['checked']);
              }
            },
          );
          print(_isCheckedList);
        });

        return _eventList;
      } else {
        // Handle the error
        print('Failed to get data from Firebase Realtime Database. '
            'Status code: ${response.statusCode}, '
            'Error message: ${response.reasonPhrase}');

        return _eventList;
      }
    }

  @override
  Widget build(BuildContext context)  {
     return MaterialApp(
       debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children:[SizedBox(height: 20,),
          Text("Your Progress",style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.bold )),Container(
            height: 400,
            width: 400,
            child: SfCartesianChart(
             primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(minimum: 0, maximum: 10, interval: 1),
            
            series: <ChartSeries>[
              ColumnSeries<ChartData, dynamic>(
                dataSource: chartDataList,
                color:  Colors.primaries[
                                      Random().nextInt(Colors.primaries.length)],
                                    xAxisName: "Dates",
                                    yAxisName: "Tasks Completed",
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
              ),
            ],
          ),
          ),
          SizedBox(height: 20,),
          Text("Remaining Tasks",style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.bold )),
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
                           
                          ),
                        );
                      },
                      itemCount: _eventList.length),
           ),
          ])
      ),) ;
      }
    

}
class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final int y;
}

